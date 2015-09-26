require 'spec_helper'
require 'shanty/plugins/cucumber_plugin'

# All classes referenced belong to the shanty project
module Shanty
  RSpec.describe(CucumberPlugin) do
    include_context('basics')

    it('adds the cucumber tag') do
      expect(described_class).to add_tags(:cucumber)
    end

    it('finds projects by calling a method to locate the ones that depend on Cucumber') do
      expect(described_class).to define_projects.with(:cucumber_projects)
    end

    it('subscribes to the test event') do
      expect(described_class).to subscribe_to(:test).with(:cucumber)
    end

    describe('#cucumber') do
      it('calls cucumber') do
        expect(subject).to receive(:system).with('cucumber')

        subject.cucumber
      end
    end
  end
end
