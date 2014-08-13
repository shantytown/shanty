require 'algorithms'

module Shanty
  # Public: Represents the link graph of projects in the repository. This class is
  # responsible for collecting up all the information the projects we have,
  # making parent/child dependency links between them, and then calculating which
  # projects need to be build by combining a Git diff with the dependency graph
  # to resolve to a list of projects required to be built.
  class Graph
    attr_reader :projects

    # Public: Initialise a ProjectLinkGraph.
    #
    # projects - An array of project instances to take and link together into
    #            a graph structure of dependencies.
    def initialize(projects)
      @projects = sort_projects(link_projects(projects))

      @project_path_trie = Containers::Trie.new

      @projects.each do |project|
        @project_path_trie[project.path] = project
      end
    end

    # Public: All the changed projects in the current repository.
    #
    # Returns an Array of Project subclasses, one for each project in the
    # repository.
    def changed
      @projects.select { |project| project.changed? }
    end

    # Public: Returns a project, if any, with the given name.
    #
    # name - The name to filter by.
    #
    # Returns an instance of a Project subclass if found, otherwise nil.
    def by_name(name)
      @projects.find { |project| project.name == name }
    end

    # Public: Returns all projects of the given types.
    #
    # *types - One or more types to filter by.
    #
    # Returns an Array of Project subclasses, one for each project in the
    # repository.
    def all_of_type(*types)
      @projects.select { |project| types.include?(project.class) }
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

    # Private: Given a list of projects, construct the parent/child
    # relationships between them given a list of their parents/children by name
    # as defined on the project instances.
    #
    # projects - An array of Project subclasses to link together.
    #
    # Returns an Array of linked projects.
    def link_projects(projects)
      projects_by_name = projects.each_with_object({}) { |project, acc| acc[project.name] = project }

      projects.each do |project|
        parent_dependencies = project.parents_by_name.map { |parent_name| projects_by_name[parent_name] }.compact

        parent_dependencies.each do |parent_dependency|
          project.add_parent(parent_dependency)
          parent_dependency.add_child(project)
        end
      end

      projects
    end

    # Private: Given a list of Project subclasses, sort them by their distance
    # from the root node (that is, the topmost node). This order is important
    # because it matches the order in which things should be build to avoid
    # missing dependencies.
    #
    # projects - An array of Project subclasses to sort.
    #
    # Returns a sorted Array of Project subclasses.
    def sort_projects(projects)
      projects.sort { |a, b| a.distance_from_root <=> b.distance_from_root }
    end
  end
end
