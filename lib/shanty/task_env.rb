require 'delegate'

module Shanty
  #
  class TaskEnv < SimpleDelegator
    alias_method :env, :__getobj__

    def graph
      @graph ||= construct_project_graph
    end

    private

    def construct_project_graph
      project_templates = Discoverer.new(env).discover_all

      Graph.new(env, project_templates).tap do |graph|
        Mutator.new(env, graph).apply_mutations
      end
    end
  end
end
