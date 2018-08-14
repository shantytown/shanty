require 'commander'
require 'spec_helper'
require 'i18n'
require 'shanty/cli'
require 'shanty/info'
require 'shanty/env'
require 'shanty/task_set'

RSpec.describe(Shanty::Cli) do
  subject { described_class.new([task_set], env, graph) }

  let(:env) { double('env') }
  let(:graph) { double('graph') }
  let(:config) { Hash.new { |h, k| h[k] = {} } }
  let(:task_set) do
    double('task set').tap do |d|
      allow(d).to receive(:tasks).and_return(
        foo: {
          klass: klass,
          options: {
            cat: {
              desc: 'test.options.cat'
            },
            dog: {
              type: :boolean,
              desc: 'test.options.dog'
            },
            catweasel: {
              required: true,
              type: :string,
              desc: 'test.options.catweasel'
            }
          },
          syntax: 'foo [--cat CAT] [--dog] --catweasel CATWEASEL',
          desc: 'test.foo.desc'
        }
      )
    end
  end
  let(:klass) do
    Class.new(Shanty::TaskSet) do
      def foo
        'foo'
      end
    end
  end

  before do
    allow(env).to receive(:config).and_return(config)
    Commander::Runner.instance_variable_set(:@singleton, nil)
  end

  describe('#tasks') do
    it('returns a list of tasks from all given task sets') do
      expect(subject.tasks.keys).to contain_exactly(:foo)
    end

    it('has the correct syntax for the foo task') do
      expect(subject.tasks[:foo][:syntax]).to eql('foo [--cat CAT] [--dog] --catweasel CATWEASEL')
    end

    it('has the correct description for the foo task') do
      expect(subject.tasks[:foo][:desc]).to eql('test.foo.desc')
    end

    it('has the correct klass for the foo task') do
      expect(subject.tasks[:foo][:klass]).to equal(klass)
    end

    it('has all the defined options available') do
      expect(subject.tasks[:foo][:options].keys).to contain_exactly(:cat, :dog, :catweasel)
    end

    it('has the correct information about the cat option') do
      expect(subject.tasks[:foo][:options][:cat]).to eql(desc: 'test.options.cat')
    end

    it('has the correct information about the dog option') do
      expect(subject.tasks[:foo][:options][:dog]).to eql(type: :boolean, desc: 'test.options.dog')
    end

    it('has the correct information about the catweasel option') do
      option = subject.tasks[:foo][:options][:catweasel]
      expect(option).to eql(required: true, type: :string, desc: 'test.options.catweasel')
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
      expect(subject).to receive(:program).with(:version, Shanty::Info::VERSION)

      subject.run
    end

    it('sets the description of the program') do
      allow(subject).to receive(:run!)
      expect(subject).to receive(:program).with(:description, Shanty::Info::DESCRIPTION)

      subject.run
    end

    it('sets up the tasks for the program') do
      allow(subject).to receive(:run!)
      expect(subject).to receive(:command)

      subject.run

      expect(subject.defined_commands).to include('foo')

      command = subject.defined_commands['foo']
      expect(command.description).to eql('test.foo.desc')

      options = command.options.map { |o| o[:description] }
      expect(options).to contain_exactly('test.options.cat', 'test.options.dog', 'test.options.catweasel')
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

      ARGV.concat(%w[xulu])

      subject.run
    end

    it('fails to run a command when run without required options') do
      # FIXME: Commander catches the exception and rethrows it with extra stuff, we should move away from commander
      expect(Commander::Runner.instance).to receive(:abort).with(
        include(I18n.t('cli.params_missing', missing: 'catweasel'))
      )

      ARGV.concat(%w[foo])

      subject.run
    end

    it('executes a command correctly when run') do
      ARGV.concat(%w[foo --cat=iamaniamscat --dog --catweasel=noiamacatweasel])

      subject.run
    end

    it('executes a command correctly when run without non-required options') do
      ARGV.concat(%w[foo --catweasel=noiamacatweasel])

      subject.run
    end

    it('fails to run a command with config options if config is in incorrect format') do
      ARGV.concat(%w[-c nic foo])

      expect do
        subject.run
      end.to raise_error(I18n.t('cli.invalid_config_param', actual: 'nic', expected: Shanty::Cli::CONFIG_FORMAT))
    end

    it('runs a command with a config option') do
      ARGV.concat(['-c nic:kim cage'])

      expect(Commander::Runner.instance).to receive(:abort)
      subject.run

      expect(config[:nic]).to eql(kim: 'cage')
    end

    it('runs a command with multiple config options') do
      ARGV.concat(['-c nic:kim cage', '-c nic:copolla cage'])

      expect(Commander::Runner.instance).to receive(:abort)
      subject.run

      expect(config[:nic]).to eql(kim: 'cage', copolla: 'cage')
    end
  end
end
