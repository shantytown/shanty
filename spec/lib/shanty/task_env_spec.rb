require 'spec_helper'
require 'shanty/task_env'

# All classes referenced belong to the shanty project
module Shanty
  RSpec.describe(TaskEnv) do
    include_context('graph')

    describe('#graph') do
      it('discovers all the projects') do
        expect(Plugin).to receive(:discover_all_projects).and_return([])

        subject.graph
      end

      it('returns a graph') do
        expect(subject.graph).to be_a(Graph)
      end
    end
  end
end
