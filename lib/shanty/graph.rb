require 'algorithms'
require 'forwardable'
require 'tsort'

module Shanty
  # Public: Represents the link graph of projects in the repository. This class is
  # responsible for collecting up all the information the projects we have,
  # making parent/child dependency links between them, and then calculating which
  # projects need to be build by combining a Git diff with the dependency graph
  # to resolve to a list of projects required to be built.
  class Graph
    extend Forwardable
    include TSort, Enumerable

    def_delegators :@projects, :<<, :length, :add, :remove
    def_delegators :sorted_projects, :each, :values, :[]

    # Public: Initialise a ProjectLinkGraph.
    #
    # project_templates - An array of project templates to take, instantiate and
    #                     link together into a graph structure of dependencies.
    def initialize(project_templates)
      @project_path_trie = Containers::Trie.new
      @project_templates = project_templates
      @projects = projects_by_path.values

      link_projects
    end

    # Public: All the changed projects in the current repository.
    #
    # Returns an Array of Project subclasses, one for each project in the
    # repository.
    def changed
      select(&:changed?)
    end

    # Public: Returns a project, if any, with the given name.
    #
    # name - The name to filter by.
    #
    # Returns an instance of a Project subclass if found, otherwise nil.
    def by_name(name)
      find { |project| project.name == name }
    end

    # Public: Returns all projects of the given types.
    #
    # *types - One or more types to filter by.
    #
    # Returns an Array of Project subclasses, one for each project in the
    # repository.
    def all_of_type(*types)
      select { |project| types.include?(project.class) }
    end

    # Public: Returns all the changed projects of the given types.
    #
    # *types - One or more types to filter by.
    #
    # Returns an Array of Project subclasses, one for each project in the
    # repository.
    def changed_of_type(*types)
      changed.select { |project| types.include?(project.class) }
    end

    # Public: Returns the project, if any, that the current working directory
    # belongs to.
    #
    # Returns an instance of a Project subclass if found, otherwise nil.
    def current
      owner_of_file(Dir.pwd)
    end

    # Public: Given a path to a file or directory (normally a path obtained
    # while looking at a Git diff), find the project that owns this file. This
    # works by finding the project with the longest path in common with the
    # file, and is very efficient because this search is backed using a Trie
    # data structure. This data structure allows worst case matching of O(m)
    # complexity.
    #
    # path - The path to the file to find the owner project.
    #
    # Returns a Project subclass if any found, otherwise nil.
    def owner_of_file(path)
      key = @project_path_trie.longest_prefix(path)
      @project_path_trie[key]
    end

    private

    def sorted_projects
      @sorted_projects ||= tsort
    end

    def tsort_each_node
      @projects.each { |p| yield p }
    end

    def tsort_each_child(project)
      projects_by_path[project.path].parents.each { |p| yield p }
    end

    def projects_by_path
      @projects_by_path ||= Hash[@project_templates.map do |project_template|
        project = project_template.type.new(project_template)
        @project_path_trie[project.path] = project
        [project.path, project]
      end]
    end

    # Private: Given a list of projects, construct the parent/child
    # relationships between them given a list of their parents/children by name
    # as defined on the project instances.
    #
    # projects - An array of Project subclasses to link together.
    #
    # Returns an Array of linked projects.
    def link_projects
      projects_by_path.each_value do |project|
        project.parents_by_path.each do |parent_path|
          parent_dependency = projects_by_path[parent_path]
          if parent_dependency.nil?
            fail("Cannot find project at path #{parent_path}, which was specified as a dependency for #{project}")
          end

          project.add_parent(parent_dependency)
          parent_dependency.add_child(project)
        end
      end
    end
  end
end
