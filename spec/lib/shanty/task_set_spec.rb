require 'spec_helper'
require 'shanty/task_set'

RSpec.describe(Shanty::TaskSet) do
  include_context('with tmp shanty')

  subject(:task_set) { test_plugin.new(env, graph) }

  let(:env) { double('env') }
  let(:graph) { double('graph') }
  let(:test_plugin) do
    Class.new(described_class) do
      desc 'foo [--cat CAT] [--dog] --catweasel CATWEASEL', 'test.foo.desc'
      option :cat, desc: 'test.options.cat'
      option :dog, type: :boolean, desc: 'test.options.dog'
      option :catweasel, required: true, type: :string, desc: 'test.options.catweasel'
      def foo(options)
        options
      end
    end
  end

  after do
    described_class.instance_variable_set(:@partial_task, nil)
  end

  describe('.tasks') do
    it('returns the registered tasks') do
      expect(test_plugin.tasks).to include(:foo)
    end
  end

  describe('.partial_task') do
    it('returns a partial task') do
      expect(test_plugin.partial_task).to eql(klass: test_plugin, options: {})
    end
  end

  describe('.desc') do
    it('sets the syntax field of the current partial task') do
      described_class.desc('foo', 'bar')

      expect(described_class.instance_variable_get(:@partial_task)).to include(syntax: 'foo')
    end

    it('sets the desc field of the current partial task') do
      described_class.desc('foo', 'bar')

      expect(described_class.instance_variable_get(:@partial_task)).to include(desc: 'bar')
    end
  end

  describe('.option') do
    it('sets the given option with the given attrs in the current partial task') do
      described_class.option('foo', bar: 'lux')

      expect(described_class.instance_variable_get(:@partial_task)[:options]).to include('foo' => { bar: 'lux' })
    end
  end

  describe('.method_added') do
    it('adds the partial task to the list of tasks with the name of the method that was added') do
      described_class.method_added(:woowoo)

      expect(described_class.instance_variable_get(:@tasks)).to include(:woowoo)
    end

    it('resets the partial task') do
      described_class.method_added(:weewah)

      expect(described_class.instance_variable_get(:@partial_task)).to be_nil
    end
  end

  describe('#env') do
    it('returns the env passed to the constructor') do
      expect(task_set.env).to eql(env)
    end
  end

  describe('#graph') do
    it('returns the graph passed to the constructor') do
      expect(task_set.graph).to eql(graph)
    end
  end
end
