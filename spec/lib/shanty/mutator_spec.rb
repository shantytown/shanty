require 'spec_helper'
require 'shanty/mutator'
require_fixture 'test_mutator'

# All classes referenced belong to the shanty project
module Shanty
  RSpec.describe(Mutator) do
    include_context('graph')
    subject { Mutator.new(env, graph) }
    let(:mutator_class) { Class.new(TestMutator) }
    let(:mutator) { mutator_class.new(env, graph) }

    describe('.inherited') do
      it('adds the inheriting mutator to the array of registered mutators') do
        Mutator.inherited(mutator_class)

        expect(Mutator.instance_variable_get(:@mutators)).to include(mutator_class)
      end
    end

    describe('.mutators') do
      it('returns any registered mutators') do
        expect(Mutator.mutators).to include(TestMutator)
      end
    end

    describe('#apply_mutations') do
      it('creates a new mutator for each registered mutator class, and calls mutate on it') do
        Mutator.instance_variable_get(:@mutators).each do |mutator_class|
          expect(mutator_class).to receive(:new).and_return(mutator)
          expect(mutator).to receive(:mutate)
        end

        subject.apply_mutations
      end
    end
  end
end
