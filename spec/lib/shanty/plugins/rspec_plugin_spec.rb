require 'spec_helper'
require 'shanty/plugins/rspec_plugin'

# All classes referenced belong to the shanty project
module Shanty
  RSpec.describe(RspecPlugin) do
    include_context('graph')

    it('adds the rspec tag') do
      expect(described_class).to add_tags(:rspec)
    end

    it('finds projects by calling a method to locate the ones that depend on RSpec') do
      expect(described_class).to define_projects.with(:rspec_projects)
    end

    it('subscribes to the test event') do
      expect(described_class).to subscribe_to(:test).with(:rspec)
    end

    describe('#rspec') do
      it('calls rspec') do
        expect(subject).to receive(:system).with('rspec')

        subject.rspec(project)
      end
    end
  end
end
