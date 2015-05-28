require 'spec_helper'
require 'shanty/task_env'

# All classes referenced belong to the shanty project
module Shanty
  RSpec.describe(TaskEnv) do
    include_context('graph')
    subject { TaskEnv.new(env) }

    describe('#env') do
      it('returns the env passed to the constructor') do
        expect(subject.env).to eql(env)
      end
    end

    describe('#graph') do
      let(:discoverer) { Discoverer.new(env) }
      let(:mutator) { Mutator.new(env, graph) }

      it('discovers all the projects') do
        expect(Plugin).to receive(:discover_all_projects).with(env).and_return([])

        subject.graph
      end

      it('returns a graph') do
        expect(subject.graph).to be_a(Graph)
      end
    end

    describe('delegations') do
      it('delegates missing methods to the env') do
        expect(env).to receive(:environment)

        subject.environment
      end
    end
  end
end
