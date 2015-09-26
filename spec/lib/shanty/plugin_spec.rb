require 'spec_helper'
require 'shanty/plugin'

# All classes referenced belong to the shanty project
module Shanty
  RSpec.describe(Plugin) do
    include_context('graph')
    let(:graph) { double('graph') }
    let(:plugin_class) do
      Class.new(described_class) do
        def foo
          []
        end
      end
    end
    subject { plugin_class.new }

    around do |example|
      plugins = described_class.instance_variable_get(:@plugins).clone
      described_class.instance_variable_set(:@plugins, [subject])
      example.run
      described_class.instance_variable_set(:@plugins, plugins)
    end

    describe('.inherited') do
      it('stores a new instance of any class that extends Plugin') do
        expect(described_class.instance_variable_get(:@plugins).size).to eq(1)
        expect(described_class.instance_variable_get(:@plugins).first).to be_instance_of(plugin_class)
      end
    end

    describe('.all_projects') do
      it('returns all the nominated projects from all the registered plugins') do
        allow(subject).to receive(:projects).and_return(project)
        expect(described_class.all_projects).to match_array(project)
      end
    end

    describe('.all_with_graph') do
      before do
        described_class.instance_variable_set(:@plugins, [subject])
      end

      it('calls #with_graph on every registered plugin') do
        expect(subject).to receive(:with_graph).with(graph)

        described_class.all_with_graph(graph)
      end
    end

    describe('.tags') do
      it('stores the given tags') do
        plugin_class.tags(:foo, :marbles)

        expect(plugin_class.instance_variable_get(:@tags)).to match_array([:foo, :marbles])
      end

      it('converts any given tags to symbols') do
        plugin_class.tags('bar', 'lux')

        expect(plugin_class.instance_variable_get(:@tags)).to match_array([:bar, :lux])
      end
    end

    describe('.projects') do
      it('stores the given globs or symbols') do
        plugin_class.projects('**/foo', :bar)

        expect(plugin_class.instance_variable_get(:@project_matchers)).to match_array(['**/foo', :bar])
      end
    end

    describe('.with_graph') do
      it('stores the passed block') do
        block = proc {}
        plugin_class.with_graph(&block)

        expect(plugin_class.instance_variable_get(:@with_graph_callbacks)).to match_array([block])
      end
    end

    describe('#projects') do
      let(:project_tree) { double('project_tree') }

      it('returns no projects if there are no matchers') do
        expect(subject.projects).to be_empty
      end

      it('returns projects matching any stored globs') do
        paths = project_paths.values.map { |p| File.join(p, 'foo') }
        plugin_class.projects('**/foo', '**/bar')
        allow(subject).to receive(:project_tree).and_return(project_tree)
        allow(project_tree).to receive(:glob).with('**/foo', '**/bar').and_return(paths)

        expect(subject.projects).to match_array(projects.values)
      end

      it('returns projects provided by the stored callbacks') do
        allow(subject).to receive(:foo).and_return(projects.values)
        plugin_class.projects(:foo)

        expect(subject.projects).to match_array(projects.values)
      end

      it('adds the current plugin to the project') do
        allow(subject).to receive(:foo).and_return([project])
        plugin_class.projects(:foo)

        expect(project).to receive(:add_plugin).with(subject)

        subject.projects
      end
    end

    describe('#with_graph') do
      it('calls the stored callbacks with the given graph') do
        block = proc {}
        plugin_class.with_graph(&block)

        expect(block).to receive(:call).with(graph)

        subject.with_graph(graph)
      end
    end
  end
end
