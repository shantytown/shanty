module Shanty
  # Public: enables mutation of the project graph
  # Common usage would be to set changed flags on projects
  class Mutator
    class << self
      attr_reader :mutators
    end

    def self.inherited(mutator)
      @mutators ||= []
      @mutators << mutator
    end

    def apply_mutations(graph)
      self.class.mutators.reduce(graph) do |acc, mutator|
        mutator.new.mutate(acc)
      end
    end
  end
end
