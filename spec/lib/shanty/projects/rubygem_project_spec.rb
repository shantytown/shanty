require 'spec_helper'
require 'shanty/projects/rubygem_project'

# All classes referenced belong to the shanty project
module Shanty
  RSpec.describe(RubygemProject) do
    include_context('graph')
    subject { RubygemProject.new(env, project_templates[:shanty]) }

    it('subscribes to the build event') do
      expect(RubygemProject.class_callbacks).to include(build: [:build_gem])
    end

    describe('#build_gem') do
      it('calls to build the gem') do
        expect(subject).to receive(:system).with('gem build *.gemspec')

        subject.build_gem
      end
    end
  end
end
