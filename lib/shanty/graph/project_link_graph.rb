require 'algorithms'
require 'graph'

# Public: Represents the link graph of projects in the repository. This class is
# responsible for collecting up all the information the projects we have,
# making parent/child dependency links between them, and then calculating which
# projects need to be build by combining a Git diff with the dependency graph
# to resolve to a list of projects required to be built.
class Shanty::Graph::ProjectLinkGraph
  # Public: The name of the file that is in the root directory of any deployable
  # projects. We use this to find some projects.
  PROJECT_FILE = 'project.json'

  # Public: The name of the Gradle settings file, containing (in Groovy format)
  # a list of all Java projects that may not necessarily be deployable. This in
  # combination with the projects containing a PROJECT_FILE allows us to collect
  # up a full listing of all projects.
  GRADLE_SETTINGS_FILE = 'settings.gradle'

  # Public: Initialise a ProjectLinkGraph.
  #
  # root_dir        - The root directory of the repository.
  # current_branch  - The name of the current branch.
  # build_number    - The current build number.
  # build_all_types - The types of project which should all be built if not
  #                   doing a full build all.
  # from_commit     - The commit to diff from. If not given, changed projects
  #                   will just return all the projects. This is the behaviour
  #                   when running locally, because we only have a reliable last
  #                   commit on CI.
  # to_commit       - The commit to diff up to. Defaults to HEAD, it's very
  #                   unlikely you will ever want to change this.
  def initialize(root_dir, current_branch, build_number, build_all_types, from_commit = nil, to_commit = 'HEAD')
    @root_dir = root_dir
    @current_branch = current_branch
    @build_number = build_number
    @build_all_types = build_all_types
    @from_commit = from_commit
    @to_commit = to_commit

    @path_trie = Containers::Trie.new
  end

  # Public: All the projects in the current repository.
  #
  # Returns an Array of Project subclasses, one for each project in the
  # repository
  def all
    return @projects unless @projects.nil?

    @projects = Shanty::Graph::Discovery.constants.each_with_object([]) do |c, acc|
      projects = Shanty::Graph::Discovery.const_get(c).new.discover(@root_dir, @current_branch, @build_number)
      acc << projects
      acc.flatten!
      acc.reject! { |item| item.nil? }
    end

    @projects = []

    # Everything must be added to the Trie first before we can start linking
    # projects together.
    @projects.each { |project| @path_trie[project.path] = project }

    @projects.each do |project|
      parent_dependencies = project.parents_by_name.map { |parent_name| by_name(parent_name, project.type) }.compact

      parent_dependencies.each do |parent_dependency|
        project.add_parent(parent_dependency)
        parent_dependency.add_child(project)
      end
    end

    @projects = sort_projects(@projects)
  end

  # Public: All the changed projects in the current repository.
  #
  # Returns an Array of Project subclasses, one for each project in the
  # repository.
  def changed
    return @changed unless @changed.nil?
    return @changed = all if @from_commit.nil?

    # Ask Git for a list of all files that have changed - just their paths
    # relative to the root of the repository - then split on the newlines so
    # we have an array of all the changes.
    diff_files = `git diff --name-only #{@from_commit} #{@to_commit}`.split("\n")

    # Call #all, the Trie needs to be populated before we can use it.
    all

    # Add all the project types which have been selecting for a build all
    changed_projects = all_of_type(*@build_all_types)

    # Now use the Trie to loop through the changes and find the project that is
    # responsible for that file.
    changed_projects += diff_files.map { |path| owner_of_file(path) }.compact

    # Now we add dependencies to the list of changed projects, as they also need
    # to be built:

    # Add all of their dependencies right down to the leaves of the graph.
    changed_projects += changed_projects.map(&:all_children).flatten

    # We sort the projects now into the correct order to be build. Note that we
    # uniq on the name and type at the end because we don't want projects to
    # build multiple times.
    @changed = sort_projects(changed_projects.uniq { |project| project.name + project.type })
  end

  # Public: Returns a project, if any, with the given name. Optionally, you can
  # specify a type to filter by too; this is useful in circumstances where two
  # projects may have the same name but different types (eg. a java project and
  # its counterpart docker embedded project).
  #
  # name - The name to filter by.
  # type - An optional type to filter by.
  #
  # Returns an instance of a Project subclass, nil if not found.
  def by_name(name, type = nil)
    all.find { |project| project.name == name && (type.nil? || project.type == type) }
  end

  # Public: Returns all projects of the given types.
  #
  # *types - One or more types to filter by.
  #
  # Returns an Array of Project subclasses, one for each project in the
  # repository.
  def all_of_type(*types)
    all.find_all { |project| types.include?(project.type) }
  end

  # Public: Returns all the changed projects of the given types.
  #
  # *types - One or more types to filter by.
  #
  # Returns an Array of Project subclasses, one for each project in the
  # repository.
  def changed_of_type(*types)
    changed.find_all { |project| types.include?(project.type) }
  end

  # Public: Returns the project, if any, that the current working directory
  # belongs to.
  #
  # type - An optional type to filter by.
  #
  # Returns a Project subclass if found.
  # Raises a RuntimeException if not found.
  def current(type = nil)
    # Call #all, the Trie needs to be populated before we can use it.
    all

    project = owner_of_file(Dir.pwd[(@root_dir.size + 1)..-1])
    raise "The current working directory is not a valid #{type.nil? ? '' : "#{type} "}project." unless project && (type.nil? || project.type == type)
    project
  end

  # Public: Draws a dependency graph for each type of project type given.
  #
  # *types - One or more types to create a dependency graph for.
  def draw_graph(*types)
    graph_dir = "#{@root_dir}/graphs"
    FileUtils.mkdir_p(graph_dir)
    types.each do |type|
      projects = all_of_type(type)
      digraph do
        projects.each do |project|
          project_name = "#{project.name} (#{project.type})"
          project.parents.each do |parent|
            parent_name = "#{parent.name} (#{parent.type})"
            red << node(project_name) << edge(project_name, parent_name)
          end
        end

        save "#{graph_dir}/#{type}", "svg"
      end
    end
  end

  # Public: Draws a dependency graph for each project in every type given.
  #
  # *types - One or more types to create dependency graphs for.
  def draw_graphs(*types)
    graph_dir = "#{@root_dir}/graphs"
    types.each do |type|
      all_of_type(type).each do |project|
        project_name = "#{project.name} (#{project.type})"

        digraph do
          project.parents.each do |parent|
            parent_name = "#{parent.name} (#{parent.type})"
            red << node(project_name) << edge(project_name, parent_name)
          end

          project.externals_by_name.each do |ext|
            triangle << node(ext)
            green << node(project_name) << edge(project_name, ext)
          end

          project.all_parents.each do |parent|
            parent_name = "#{parent.name} (#{parent.type})"
            parent.parents.each do |grandparent|
              grandparent_name = "#{grandparent.name} (#{grandparent.type})"
              red << node(parent_name) << edge(parent_name, grandparent_name)
            end
          end

          FileUtils.mkdir_p("#{graph_dir}/#{project.name}")
          save("#{graph_dir}/#{project.name}/#{project.name}", 'svg')
        end
      end
    end
  end

  private
  # Private: Returns a list of projects that are deployable; that is, they have
  # a PROJECT_FILE in their root directory. Note that these Project instances
  # do not have any parents or children linked to them at this stage.
  #
  # Returns an Array of Project subclasses, one for each project with a
  # PROJECT_FILE in their root directory.
  def deployable_projects
    Dir["#{@root_dir}/**/#{PROJECT_FILE}"].map do |project_file_path|
      rel_path = File.dirname(project_file_path)[(@root_dir.length + 1)..-1]

      json = File.open(project_file_path) { |file| JSON.load(file)}
      name = json.delete('name')
      type = json.delete('type')

      raise "Bad type for project #{name}." if type.nil?

      Project.create(type, name, rel_path, @current_branch, @root_dir, @build_number, json)
    end
  end

  # Private: Returns a list of projects as specified in the Gradle settings
  # file. Note that these Project instances do not have any parents or children
  # linked to them at this stage.
  #
  # Returns an Array of Project subclasses, one for each project in the Gradle
  # settings file.
  def gradle_projects
    @gradle_projects ||= File.open(File.join(@root_dir, GRADLE_SETTINGS_FILE)) do |settings_file|
      settings_file.each_line.each_with_object([]) do |line, acc|
        next unless line =~ /include ['"]([^'"]+)/
        gradle_project_path = $1

        rel_path = gradle_project_path[1..-1].gsub(':', '/')
        name = File.basename(rel_path)

        # This is a special case, we do not want this to be a Java project. It just needs to have a build.gradle because
        # some people like editing this in IntelliJ to get the cucumber IDE helpers.
        next if name == 'automation-tests'

        project = JavaProject.new(name, rel_path, @current_branch, @root_dir, @build_number, deployable: false)

        acc << project
      end
    end
  end

  # Private: Given a list of Project subclasses, sort them by their distance
  # from the root node (that is, the topmost node). This order is important
  # because it matches the order in which things should be build to avoid
  # missing dependencies.
  #
  # projects - An array of Project subclasses to sort.
  #
  # Returns a sorted Array of Project subclasses.
  def sort_projects(projects)
    projects.sort { |a, b| a.distance_from_root <=> b.distance_from_root }
  end

  # Private: Given a path to a file (normally a path obtained while looking at
  # a Git diff), find the project that owns this file. This works by finding
  # the project with the longest path in common with the file, and is very
  # efficient because this search is backed using a Trie data structure. This
  # data structure allows worst case matching of O(m) complexity.
  #
  # path - The path to the file to find the owner project.
  #
  # Returns a Project subclass if any found, otherwise nil.
  def owner_of_file(path)
    key = @path_trie.longest_prefix(path)
    @path_trie[key]
  end
end
