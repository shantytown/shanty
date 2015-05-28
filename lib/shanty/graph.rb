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
    include Enumerable

    def_delegators :@projects, :<<, :empty?, :length, :each, :values, :[], :inspect, :to_s

    # Public: Initialise a Graph.
    #
    # project_path_trie -
    # projects - An array of projects to use. These are expected to be pre-sorted and linked via the ProjectLinker.
    def initialize(project_path_trie, projects)
      @project_path_trie = project_path_trie
      @projects = projects
    end

    # Public: Returns a project, if any, with the given name.
    #
    # name - The name to filter by.
    #
    # Returns an instance of a Project subclass if found, otherwise nil.
    def by_name(name)
      find { |project| project.name == name }
    end

    # Public: Returns all projects that have the given tags.
    #
    # *plugins - One or more plugins to filter by.
    #
    # Returns an Array of Project subclasses, one for each project in the
    # repository.
    def all_with_tags(*tags)
      return [] if tags.empty?
      select do |project|
        project_tags = project.tags.map(&:to_sym)
        tags.map(&:to_sym).all? { |tag| project_tags.include?(tag) }
      end
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
      @project_path_trie[@project_path_trie.longest_prefix(path)]
    end

    # Public: Given a path, find all the projects at or below this path.
    #
    # path - The path to search within.
    #
    # Returns an Array of project subclasses, one for each project below
    # this path.
    def projects_within_path(path)
      select { |project| project.path.start_with?(path) }
    end

    def select
      sub_graph(super)
    end

    private

    def sub_graph(projects)
      self.class.new(@project_path_trie, projects)
    end
  end
end
