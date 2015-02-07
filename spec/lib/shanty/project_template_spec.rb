require 'spec_helper'
require 'shanty/project_template'

# All classes referenced belong to the shanty project
module Shanty
  RSpec.describe(ProjectTemplate) do
    include_context('basics')
    let(:project_path) { project_paths[:shanty] }
    subject { ProjectTemplate.new(env, project_path) }

    describe('.new') do
      it('raises an exception if the given path is not a valid directory') do
        allow(File).to receive(:directory?).and_return(false)

        expect { subject }.to raise_error('Path to project must be a directory.')
      end
    end

    describe('#setup!') do
      it('does nothing if the Shantyfile does not exist') do
        allow(File).to receive(:exist?).and_return(false)
        expect(subject).to_not receive(:instance_eval)

        subject.setup!
      end

      it('evals the Shantyfile within the project instance') do
        shantyfile_path = File.join(project_path, 'Shantyfile')
        expect(subject).to receive(:instance_eval).with(File.read(shantyfile_path), shantyfile_path)

        subject.setup!
      end
    end

    describe('#name') do
      it('defaults the name to the basename of the given path') do
        expect(subject.name).to eql(File.basename(project_path))
      end
    end

    describe('#type') do
      it('defaults the type to StaticProject') do
        expect(subject.type).to eql(StaticProject)
      end
    end

    describe('#priority') do
      it('defaults the priority to 0') do
        expect(subject.priority).to eql(0)
      end
    end

    describe('#plugins') do
      it('defaults the plugins to an empty array') do
        expect(subject.plugins).to eql([])
      end
    end

    describe('#parents') do
      it('defaults the parents to an empty array') do
        expect(subject.parents).to eql([])
      end
    end

    describe('#options') do
      it('defaults the options to an empty object') do
        expect(subject.options).to eql({})
      end
    end

    describe('#plugin') do
      let(:plugin) { Class.new }

      it('adds the given plugin to the plugins array') do
        subject.plugin(plugin)

        expect(subject.plugins).to include(plugin)
      end
    end

    describe('#parent') do
      let(:parent) { 'foo' }

      it('adds the given parent to the parents array') do
        subject.parent('/foo')

        expect(subject.parents).to include('/foo')
      end

      it('expands the path if it is a relative path') do
        subject.parent('foo')

        expect(subject.parents).to include(File.join(env.root, 'foo'))
      end
    end

    describe('#option') do
      it('adds the given option to the parents hash') do
        subject.option('key', 'value')

        expect(subject.options).to include('key' => 'value')
      end
    end

    describe('#env') do
      it('returns the env passed into the constructor') do
        expect(subject.env).to eql(env)
      end
    end

    describe('#path') do
      it('returns the path passed into the constructor') do
        expect(subject.path).to eql(project_path)
      end
    end

    describe('#after_create') do
      let(:block) { proc {} }
      let(:replacement_block) { proc {} }

      before do
        subject.instance_variable_set(:@after_create, block)
      end

      it('returns the value of after_create if no block is given') do
        expect(subject.after_create).to eql(block)
      end

      it('sets the value of after_create to the given block') do
        subject.after_create(&replacement_block)

        expect(subject.instance_variable_get(:@after_create)).to eql(replacement_block)
      end
    end
  end
end
