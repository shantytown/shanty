require 'spec_helper'
require 'shanty/cli'
require 'shanty/env'
require 'shanty/info'
require 'shanty/task_env'
require_fixture 'test_task_set'

# All classes referenced belong to the shanty project
module Shanty
  RSpec.describe(Cli) do
    let(:env) { Env.new }
    let(:task_env) { TaskEnv.new(env) }
    let(:task_sets) { [TestTaskSet] }
    subject { Cli.new(env, task_sets) }

    describe('.new') do
      it('sets #env') do
        expect(subject.env).to equal(env)
      end
    end

    describe('#task_env') do
      it('returns a TaskEnv wrapping the passed in Env') do
        expect(subject.task_env).to be_a(TaskEnv)
        expect(subject.task_env).to have_attributes(env: env)
      end
    end

    describe('#tasks') do
      it('returns a list of tasks from all given task sets') do
        expect(subject.tasks.keys).to contain_exactly(:foo)

        command = subject.tasks[:foo]
        expect(command[:syntax]).to eql('foo --bonkers BONKERS [--cats] [--dogs DOGS]')
        expect(command[:desc]).to eql('test.foo.desc')
        expect(command[:klass]).to equal(TestTaskSet)

        options = command[:options]
        expect(options.keys).to contain_exactly(:bonkers, :cats, :dogs)
        expect(options[:bonkers]).to eql(required: true, desc: 'test.options.bonkers')
        expect(options[:cats]).to eql(type: :boolean, desc: 'test.options.cats')
        expect(options[:dogs]).to eql(type: :string, desc: 'test.options.dogs')

        params = command[:params]
        expect(params.keys).to contain_exactly(:bar)
      end
    end

    describe('#run') do
      before do
        allow(subject).to receive(:program).and_call_original
        allow(subject).to receive(:command).and_call_original
        allow(subject).to receive(:run!)
      end

      it('sets the name of the program') do
        expect(subject).to receive(:program).with(:name, 'Shanty')

        subject.run
      end

      it('sets the version of the program') do
        expect(subject).to receive(:program).with(:version, Info::VERSION)

        subject.run
      end

      it('sets the description of the program') do
        expect(subject).to receive(:program).with(:version, Info::VERSION)

        subject.run
      end

      it('sets up the tasks for the program') do
        expect(subject).to receive(:command)
        expect(subject.commands).to include('foo')

        command = subject.commands['foo']
        expect(command.description).to eql('test.foo.desc')

        options = command.options.map { |o| o[:description] }
        expect(options).to contain_exactly('test.options.bonkers', 'test.options.cats', 'test.options.dogs')

        subject.run
      end

      it('runs the CLI program') do
        expect(subject).to receive(:run!)

        subject.run
      end
    end
  end
end
