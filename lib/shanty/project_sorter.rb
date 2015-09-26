require 'algorithms'
require 'forwardable'
require 'tsort'

require 'shanty/graph'

module Shanty
  # Public: Sorts projects using Tarjan's strongly connected components algorithm.
  class ProjectSorter
    include TSort

    # Public: Initialise a ProjectLinker.
    #
    # projects - An array of projects to use. These will be mutated and sorted when the linking takes place.
    def initialize(projects)
      @projects = projects
    end

    # Private: Given a list of projects, sort them and construct a graph.
    #
    # The sorting uses Tarjan's strongly connected components algorithm.
    #
    # Returns a Graph with the projects sorted.
    def sort
      Graph.new(project_path_trie, tsort)
    end

    private

    def tsort_each_node
      @projects.each { |p| yield p }
    end

    def tsort_each_child(project)
      project_path_trie.get(project.path).parents.each { |p| yield p }
    end

    def project_path_trie
      @project_path_trie ||= Containers::Trie.new.tap do |trie|
        @projects.map { |project| trie[project.path] = project }
      end
    end
  end
end
