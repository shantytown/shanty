module Shanty
  # Public: enables mutation of the project graph
  # Common usage would be to set changed flags on projects
  class Mutator
    attr_reader :env, :graph

    def initialize(env, graph)
      @env = env
      @graph = graph
    end

    def self.inherited(mutator)
      mutators << mutator
    end

    def self.mutators
      @mutators ||= []
    end

    def apply_mutations
      self.class.mutators.each do |mutator|
        mutator.new(@env, @graph).mutate
      end
    end
  end
end
