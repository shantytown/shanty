require 'spec_helper'
require 'shanty/mutators/bundler_mutator'
require 'shanty/plugins/bundler_plugin'

# All classes referenced belong to the shanty project
module Shanty
  RSpec.describe(BundlerMutator) do
    include_context('graph')
    subject { BundlerMutator.new(env, graph) }

    describe '#mutate' do
      it('includes the bundler plugin into any projects with a Gemfile') do
        expect(BundlerPlugin).to receive(:add_to_project).with(graph.owner_of_file(root))

        subject.mutate
      end
    end
  end
end
