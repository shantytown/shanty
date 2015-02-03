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
      project_templates = Dir.chdir(root) do
        Discoverer.new(env).discover_all.sort_by(&:priority).reverse.uniq(&:path)
      end

      Graph.new(env, project_templates).tap do |graph|
        Mutator.new(env, graph).apply_mutations
      end
    end
  end
end
