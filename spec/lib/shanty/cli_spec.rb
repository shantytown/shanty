require 'commander'
require 'spec_helper'
require 'i18n'
require 'shanty/cli'
require 'shanty/info'
require 'shanty/env'
require 'shenanigans/hash/to_ostruct'
require_fixture 'test_task_set'

# All classes referenced belong to the shanty project
module Shanty
  RSpec.describe(Cli) do
    let(:task_sets) { [TestTaskSet] }
    subject { Cli.new(task_sets) }

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
        expect(subject.defined_commands).to include('foo')

        command = subject.defined_commands['foo']
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

      it('fails to run with no command specified') do
        expect(Commander::Runner.instance).to receive(:abort).with('invalid command. Use --help for more information')
        subject.run
      end

      it('fails to run an invalid command') do
        expect(Commander::Runner.instance).to receive(:abort).with('invalid command. Use --help for more information')

        ARGV.concat(%w(xulu))

        subject.run
      end

      it('fails to run a command when run without required options') do
        # FIXME: Commander catches the exception and rethrows it with extra stuff, we should move away from commander
        expect(Commander::Runner.instance).to receive(:abort).with(
          include(I18n.t('cli.params_missing', missing: 'catweasel'))
        )

        ARGV.concat(%w(foo))

        subject.run
      end

      it('executes a command correctly when run') do
        ARGV.concat(%w(foo --cat=iamaniamscat --dog --catweasel=noiamacatweasel))

        subject.run
      end

      it('executes a command correctly when run without non-required options') do
        ARGV.concat(%w(foo --catweasel=noiamacatweasel))

        subject.run
      end

      it('fails to run a command with config options if config is in incorrect format') do
        ARGV.concat(%w(-c nic foo))

        expect do
          subject.run
        end.to raise_error(I18n.t('cli.invalid_config_param', actual: 'nic', expected: Cli::CONFIG_FORMAT))
      end

      it('runs a command with a config option') do
        ARGV.concat(['-c nic:kim cage'])

        subject.run

        expect(Env.config.nic).to eql({ kim: 'cage' }.to_ostruct)
      end

      it('runs a command with multiple config options') do
        ARGV.concat(['-c nic:kim cage', '-c nic:copolla cage'])

        subject.run

        expect(Env.config.nic).to eql({ kim: 'cage', copolla: 'cage' }.to_ostruct)
      end
    end
  end
end
