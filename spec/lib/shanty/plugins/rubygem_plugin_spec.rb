require 'spec_helper'
require 'shanty/plugins/rubygem_plugin'

# All classes referenced belong to the shanty project
module Shanty
  RSpec.describe(RubygemPlugin) do
    include_context('basics')

    it('adds the rubygem tag') do
      expect(described_class).to add_tags(:rubygem)
    end

    it('finds projects that have a *.gemspec file') do
      expect(described_class).to define_projects.with('**/*.gemspec')
    end

    it('subscribes to the build event') do
      expect(described_class).to subscribe_to(:build).with(:build_gem)
    end

    describe('#build_gem') do
      it('calls gem build') do
        expect(subject).to receive(:system).with('gem build *.gemspec')

        subject.build_gem
      end
    end
  end
end
