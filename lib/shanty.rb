require 'i18n'
require 'pathname'
require 'pry'

require 'shanty/cli'
require 'shanty/discoverers/shantyfile'
require 'shanty/graph'
require 'shanty/global'
require 'shanty/mutators/git'
require 'shanty/tasks/basic'

module Shanty
  # Main shanty class
  class Shanty
    GEM_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))

    def start!
      setup_i18n
      Cli.new(graph).run
    end

    def graph
      @graph ||= construct_project_graph
    end

    private

    def setup_i18n
      I18n.enforce_available_locales = true
      I18n.load_path = Dir[File.join(GEM_ROOT, 'translations', '*.yml')]
    end

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
