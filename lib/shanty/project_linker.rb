require 'algorithms'
require 'forwardable'
require 'tsort'

require 'shanty/graph'

module Shanty
  # Public:
  class ProjectLinker
    include TSort

    # Public: Initialise a ProjectLinker.
    #
    # projects - An array of projects to use. These will be mutated and sorted when the linking takes place.
    def initialize(projects)
      @projects = projects
    end

    # Private: Given a list of projects, construct the parent/child
    # relationships between them given a list of their parents/children by name
    # as defined on the project instances.
    #
    # Returns a Graph with the projects linked and sorted.
    def link
      @projects.each do |project|
        project.parents_by_path.each do |parent_path|
          parent_dependency = project_path_trie.get(parent_path)
          if parent_dependency.nil?
            fail("Cannot find project at path #{parent_path}, which was specified as a dependency for #{project}")
          end

          project.add_parent(parent_dependency)
        end
      end

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
