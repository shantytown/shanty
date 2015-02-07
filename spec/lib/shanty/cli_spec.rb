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
        expect(command[:syntax]).to eql('foo [--cat CAT] [--dog] --catweasel CATWEASEL')
        expect(command[:desc]).to eql('test.foo.desc')
        expect(command[:klass]).to equal(TestTaskSet)

        options = command[:options]
        expect(options.keys).to contain_exactly(:cat, :dog, :catweasel)
        expect(options[:cat]).to eql(desc: 'test.options.cat')
        expect(options[:dog]).to eql(type: :boolean, desc: 'test.options.dog')
        expect(options[:catweasel]).to eql(required: true, type: :string, desc: 'test.options.catweasel')
      end
    end

    describe('#run') do
      before do
        loop do
          ARGV.pop
          break if ARGV.empty?
        end

        allow(subject).to receive(:program).and_call_original
        allow(subject).to receive(:command).and_call_original
      end

      it('sets the name of the program') do
        allow(subject).to receive(:run!)
        expect(subject).to receive(:program).with(:name, 'Shanty')

        subject.run
      end

      it('sets the version of the program') do
        allow(subject).to receive(:run!)
        expect(subject).to receive(:program).with(:version, Info::VERSION)

        subject.run
      end

      it('sets the description of the program') do
        allow(subject).to receive(:run!)
        expect(subject).to receive(:program).with(:version, Info::VERSION)

        subject.run
      end

      it('sets up the tasks for the program') do
        allow(subject).to receive(:run!)
        expect(subject).to receive(:command)
        expect(subject.commands).to include('foo')

        command = subject.commands['foo']
        expect(command.description).to eql('test.foo.desc')

        options = command.options.map { |o| o[:description] }
        expect(options).to contain_exactly('test.options.cat', 'test.options.dog', 'test.options.catweasel')

        subject.run
      end

      it('runs the CLI program') do
        allow(subject).to receive(:run!)
        expect(subject).to receive(:run!)

        subject.run
      end

      xit('fails to run with no command specified') do
        subject.run
      end

      xit('fails to run an invalid command') do
        ARGV.concat(%w(xulu))

        subject.run
      end

      xit('fails to run a command when run without required options') do
        ARGV.concat(%w(foo))

        subject.run
      end

      it('executes a command correctly when run') do
        ARGV.concat(%w(foo --cat=iamaniamscat --dog --catweasel=noiamacatweasel))

        subject.run
      end

      xit('executes a command correctly when run without non-required options') do
        ARGV.concat(%w(foo --catweasel=noiamacatweasel))

        subject.run
      end
    end
  end
end
