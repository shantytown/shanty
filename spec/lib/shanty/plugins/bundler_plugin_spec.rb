require 'spec_helper'
require 'shanty/plugins/bundler_plugin'

# All classes referenced belong to the shanty project
module Shanty
  RSpec.describe(BundlerPlugin) do
    include_context('basics')

    it('subscribes to the build event') do
      expect(BundlerPlugin.instance_variable_get(:@class_callbacks)).to include(build: [:bundle_install])
    end

    describe('#bundle_install') do
      it('calls bundler install') do
        expect(subject).to receive(:system).with('bundle install --quiet')

        subject.bundle_install
      end
    end
  end
end
