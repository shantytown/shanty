require 'spec_helper'
require 'shanty/plugins/bundler_plugin'

# All classes referenced belong to the shanty project
module Shanty
  RSpec.describe(BundlerPlugin) do
    include_context('basics')

    it('adds the bundler tag') do
      expect(described_class).to add_tags(:bundler)
    end

    it('finds projects that have a Gemfile') do
      expect(described_class).to define_projects.with('**/Gemfile')
    end

    it('subscribes to the build event') do
      expect(described_class).to subscribe_to(:build).with(:bundle_install)
    end

    describe('#bundle_install') do
      it('calls bundler install') do
        expect(subject).to receive(:system).with('bundle install --quiet')

        subject.bundle_install
      end
    end
  end
end
