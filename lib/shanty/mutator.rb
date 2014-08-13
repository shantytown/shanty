require "deep_clone"

module Shanty
  class Mutator
    @@mutators = []

    def self.inherited(mutator)
      @@mutators << mutator
    end

    def self.apply_mutations(graph)
      @@mutators.inject(graph) do |mutator, acc|
        graph = mutator.new.mutate(acc)
      end
    end
  end
end
