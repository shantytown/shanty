require 'pathname'
require 'pry'

require 'shanty/discoverers/shantyfile'
require 'shanty/mutators/git'
require 'shanty/graph'

module Shanty
  # Main shanty class
  class Shanty
    def initialize
    end

    def root
      @root ||= find_root
    end

    def graph
      @graph ||= construct_project_graph
    end

    private

    def find_root
      if root_dir.nil?
        fail 'Could not find a .shantyroot file in this or any parent directories. \
             Please run `shanty init` in the directory you want to be the root of your project structure.'
      end
      root_dir
    end

    def root_dir
      Pathname.new(Dir.pwd).ascend do |d|
        return d if d.join('.shantyroot').exist?
      end
    end

    def construct_project_graph
      project_templates = Dir.chdir(root) do
        Discoverer.new.discover_all
      end

      projects = project_templates.map do |project_template|
        project_template.type.new(project_template)
      end

      graph = Graph.new(projects)

      Mutator.new.apply_mutations(graph)
    end
  end
end
