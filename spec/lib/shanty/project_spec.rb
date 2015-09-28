require 'spec_helper'
require 'shanty/project'

# All classes referenced belong to the shanty project
module Shanty
  RSpec.describe(Project) do
    include_context('graph')
    subject { Shanty::Project.new(project_path) }

    describe('#name') do
      it('returns the name from the project in the constructor') do
        expect(subject.name).to eql('one')
      end
    end

    describe('#path') do
      it('returns the path from the project in the constructor') do
        expect(subject.path).to eql(project_path)
      end
    end

    describe('#tags') do
      it('defaults the tags to an empty array') do
        expect(subject.tags).to eql([])
      end
    end

    describe('#options') do
      it('defaults the options to an empty object') do
        expect(subject.options).to eql({})
      end
    end

    describe('#add_plugin') do
      it('adds the given plugin to the project') do
        plugin = double('plugin')

        subject.add_plugin(plugin)

        expect(subject.instance_variable_get(:@plugins)).to match_array([plugin])
      end
    end

    describe('#remove_plugin') do
      it('removes any plugins of the given class') do
        plugin_class = Class.new
        plugin = plugin_class.new
        subject.instance_variable_set(:@plugins, [plugin])

        subject.remove_plugin(plugin_class)

        expect(subject.instance_variable_get(:@plugins)).to eql([])
      end
    end

    describe('#publish') do
      before { subject.add_plugin(plugin) }
      let(:plugin) { double('plugin') }

      it('skips over any plugins that are not subscribed to the event') do
        allow(plugin).to receive(:subscribed?).and_return(false)

        subject.publish(:foo)

        expect(subject).to_not receive(:publish)
      end

      it('publishes the event on any listening plugins') do
        allow(plugin).to receive(:subscribed?).and_return(true)

        expect(plugin).to receive(:publish).with(:foo, subject, :bar, :lux)

        subject.publish(:foo, :bar, :lux)
      end

      it('returns false early if any of the plugin publishes return false') do
        next_plugin = double('next plugin')
        project.add_plugin(next_plugin)
        allow(plugin).to receive(:subscribed?).and_return(true)
        expect(plugin).to receive(:publish).and_return(false)

        expect(subject.publish(:foo)).to be(false)
        expect(next_plugin).to_not receive(:subscribed?)
      end
    end

    describe('#all_artifacts') do
      it('defaults the artifacts to an empty array') do
        expect(subject.all_artifacts).to eql([])
      end
    end

    describe('#to_s') do
      it('returns a simple string representation of the project') do
        expect(subject.to_s).to eql('one')
      end
    end

    describe('#inspect') do
      it('returns a detailed string representation of the project') do
        expect(subject.inspect).to eql({
          name: 'one',
          path: project_path,
          tags: [],
          options: {},
          parents: []
        }.inspect)
      end
    end
  end
end
