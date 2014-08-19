require 'pathname'
require 'pry'

require 'shanty/discoverers/shantyfile'
require 'shanty/mutators/git'
require 'shanty/graph'
require 'shanty/global'
require 'shanty/tasks/base'
require 'shanty/tasks/ruby'

module Shanty
  # Main shanty class
  class Shanty
    def initialize
    end

    def graph
      @graph ||= construct_project_graph
    end

    private

    def construct_project_graph
      project_templates = Dir.chdir(Global.root) do
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
