require 'spec_helper'
require 'shanty/project'

# All classes referenced belong to the shanty project
module Shanty
  RSpec.describe(Project) do
    include_context('graph')
    subject { Project.new(env, project_template) }

    describe('#setup!') do
      it('adds all the plugins from the project template to the project') do
        project_template.plugins.each do |plugin|
          expect(plugin).to receive(:add_to_project).with(subject)
        end

        subject.setup!
      end

      it('evaluates the after_create block from the project template if given') do
        block_called = false
        project_template.after_create { block_called = true }

        subject.setup!

        expect(block_called).to be(true)
      end
    end

    describe('#name') do
      it('returns the name from the project template in the constructor') do
        expect(subject.name).to equal(project_template.name)
      end
    end

    describe('#path') do
      it('returns the path from the project template in the constructor') do
        expect(subject.path).to equal(project_template.path)
      end
    end

    describe('#options') do
      it('returns the options from the project template in the constructor') do
        expect(subject.options).to equal(project_template.options)
      end
    end

    describe('#parents_by_path') do
      it('returns the parents from the project template in the constructor') do
        expect(subject.parents_by_path).to equal(project_template.parents)
      end
    end

    describe('#artifact_paths') do
      it('returns an empty array by default') do
        expect(subject.artifact_paths).to eql([])
      end
    end

    describe('#to_s') do
      it('returns a simple string representation of the project') do
        expect(subject.to_s).to eql("Name: #{project_template.name}, Type: Shanty::Project")
      end
    end

    describe('#inspect') do
      it('returns a detailed string representation of the project') do
        expect(subject.inspect).to eql({
          name: project_template.name,
          path: project_template.path,
          options: {},
          parents_by_path: [],
          changed: false
        }.inspect)
      end
    end

    describe('#within_project_dir') do
      it('does nothing if there is no block given') do
        expect(Dir).to_not receive(:chdir)

        subject.within_project_dir
      end

      it('yields the given block') do
        expect { |b| subject.within_project_dir(&b) }.to yield_with_no_args
      end

      it('yields the given block with the correct working directory') do
        subject.within_project_dir do
          expect(Dir.pwd).to eql(project_template.path)
        end
      end

      it('changes the working directory back at the end') do
        expected_pwd = Dir.pwd

        subject.within_project_dir

        expect(Dir.pwd).to eql(expected_pwd)
      end
    end
  end
end
