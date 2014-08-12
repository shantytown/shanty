require 'algorithms'

# Public: Represents the link graph of projects in the repository. This class is
# responsible for collecting up all the information the projects we have,
# making parent/child dependency links between them, and then calculating which
# projects need to be build by combining a Git diff with the dependency graph
# to resolve to a list of projects required to be built.
module Shanty
  class Graph
    # Public: Initialise a ProjectLinkGraph.
    #
    # projects - An array of project instances to take and link together into
    #            a graph structure of dependencies.
    def initialize(projects)
      @projects = sort_projects(link_projects(projects))
    end

    # Public: All the changed projects in the current repository.
    #
    # Returns an Array of Project subclasses, one for each project in the
    # repository.
    def changed
      @projects.filter { |project| project.changed? }
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
    # FIXME: Uses trie, cannot use.
    def current(type = nil)
      # Call #all, the Trie needs to be populated before we can use it.
      all

      project = owner_of_file(Dir.pwd[(@root_dir.size + 1)..-1])
      raise "The current working directory is not a valid #{type.nil? ? '' : "#{type} "}project." unless project && (type.nil? || project.type == type)
      project
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
      projects_by_name = projects.each_with_object { |project, acc| acc[project.name] = project }

      projects.map do |project|
        parent_dependencies = project.parents_by_name.map { |parent_name| projects_by_name[parent_name] }.compact

        parent_dependencies.each do |parent_dependency|
          project.add_parent(parent_dependency)
          parent_dependency.add_child(project)
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
  end
end
