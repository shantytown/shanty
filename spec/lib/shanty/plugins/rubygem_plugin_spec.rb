require 'spec_helper'
require 'shanty/plugins/rubygem_plugin'

# All classes referenced belong to the shanty project
module Shanty
  RSpec.describe(RubygemPlugin) do
    include_context('basics')

    it('subscribes to the test event') do
      expect(RubygemPlugin.instance_variable_get(:@class_callbacks)).to include(build: [:build_gem])
    end

    describe('#build_gem') do
      it('calls gem build') do
        expect(subject).to receive(:system).with('gem build *.gemspec')

        subject.build_gem
      end
    end
  end
end
