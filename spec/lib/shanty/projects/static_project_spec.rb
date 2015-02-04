require 'spec_helper'
require 'shanty/projects/static_project'

# All classes referenced belong to the shanty project
module Shanty
  RSpec.describe(StaticProject) do
    include_context('graph')
    subject { StaticProject.new(env, project_template) }

    it('subscribes to the build event') do
      expect(StaticProject.class_callbacks).to include(build: [:tar_project])
    end

    describe('#tar_project') do
      it('gzip tars up the project') do
        artifact_path = File.join(env.root, 'build', 'shanty-1.tar.gz')
        expect(subject).to receive(:system).with("tar -czvf #{artifact_path} .")

        subject.tar_project
      end
    end

    describe('#artifact_paths') do
      before do
        ENV['SHANTY_BUILD_NUMBER'] = '123'
      end

      after do
        ENV.delete('SHANTY_BUILD_NUMBER')
      end

      it('returns the correct path to the tar file') do
        expected_path = File.join(env.root, 'build', 'shanty-123.tar.gz')
        expect(subject.artifact_paths).to include(expected_path)
      end

      it('uses the artifact_name option if set') do
        expected_path = File.join(env.root, 'build', 'foo-123.tar.gz')
        subject.options['artifact_name'] = 'foo'
        expect(subject.artifact_paths).to include(expected_path)
      end
    end
  end
end
