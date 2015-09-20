require 'spec_helper'
require 'shanty/plugin'

require_fixture 'test_plugin'
require_fixture 'test_project_with_plugin'

# All classes referenced belong to the shanty project
module Shanty
  RSpec.describe(Plugin) do
    include_context('basics')
    subject { TestPlugin }
    let(:project) { TestProjectWithPlugin.new(project_path) }
    let(:callbacks) { [%i(foo bar), %i(cats dogs rabies)] }

    describe('.add_to_project') do
      it('includes the plugin into the singleton class of the given project') do
        expect(project.singleton_class).to receive(:include).with(subject)

        subject.add_to_project(project)
      end

      it('calls subscribe on the project for each callback in the plugin') do
        callbacks.each do |callback|
          # Once for printing nice messages about the task being executed.
          expect(project).to receive(:subscribe).with(callback.first)
          # And secondly for the actual subscriptions.
          expect(project).to receive(:subscribe).with(*callback)
        end

        subject.add_to_project(project)
      end
    end

    describe('.subscribe') do
      it('stores all the given arguments in the callbacks') do
        expect(subject.instance_variable_get(:@callbacks)).to contain_exactly(*callbacks)
      end
    end
  end
end
