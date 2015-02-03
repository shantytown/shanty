require 'spec_helper'
require 'shanty/mutator'
require_fixture 'test_mutator'

# All classes referenced belong to the shanty project
module Shanty
  RSpec.describe(Mutator) do
    describe('#mutators') do
      it('finds mutators') do
        expect(Mutator.mutators).to include(TestMutator)
      end
    end
  end
end
