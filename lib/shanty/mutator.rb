require 'shanty/util'

module Shanty
  # Public: enables mutation of the project graph
  # Common usage would be to set changed flags on projects
  class Mutator
    class << self
      attr_reader :mutators
    end

    def self.inherited(mutator)
      Util.logger.debug("Detected mutator #{mutator}")
      @mutators ||= []
      @mutators << mutator
    end

    def apply_mutations(graph)
      self.class.mutators.each do |mutator|
        mutator.new.mutate(graph)
      end
    end
  end
end
