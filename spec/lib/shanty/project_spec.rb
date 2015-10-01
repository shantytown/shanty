require 'spec_helper'
require 'shanty/project'

RSpec.describe(Shanty::Project) do
  include_context('workspace')
  subject { described_class.new(project_path, env) }
  let(:env) do
    double('env').tap do |d|
      allow(d).to receive(:root) { root }
    end
  end
  let(:plugin) { double('plugin') }
  let(:plugin_class) { double('plugin class') }

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

  describe('#config') do
    it('defaults the config to an empty object') do
      expect(subject.config).to eql({})
    end
  end

  describe('#add_plugin') do
    it('adds the given plugin to the project') do
      allow(plugin_class).to receive(:new).and_return(plugin)

      subject.add_plugin(plugin_class)

      expect(subject.instance_variable_get(:@plugins)).to match_array([plugin])
    end
  end

  describe('#remove_plugin') do
    it('removes any plugins of the given class') do
      subject.instance_variable_set(:@plugins, [plugin])
      allow(plugin).to receive(:is_a?).with(plugin_class).and_return(true)

      subject.remove_plugin(plugin_class)

      expect(subject.instance_variable_get(:@plugins)).to eql([])
    end
  end

  describe('#all_artifacts') do
    it('defaults the artifacts to an empty array') do
      expect(subject.all_artifacts).to eql([])
    end
  end

  describe('#changed?') do
    before do
      # FIXME: Remove this when the default of changed is properly set to
      # false once changed detection is actually working.
      subject.instance_variable_set(:@changed, false)
    end

    it('defaults changed to false') do
      pending(<<-eof)
        This will only pass once the default value is set to true when we
        have proper change detection working.
      eof
      # FIXME: Delete the following setup eventually.
      subject.instance_variable_set(:@changed, true)

      expect(subject.changed?).to be(false)
    end

    it('returns true if the changed flag is true on the current project') do
      subject.instance_variable_set(:@changed, true)

      expect(subject.changed?).to be(true)
    end

    it('returns true if any of the parents are changed') do
      parent = double('parent')
      allow(parent).to receive(:add_child)
      allow(parent).to receive(:changed?).and_return(true)
      subject.add_parent(parent)

      expect(subject.changed?).to be(true)
    end

    it('returns false if the changed flag is false and the parents are unchanged') do
      expect(subject.changed?).to be(false)
    end
  end

  describe('#changed!') do
    it('adds the changed flag to true on the current project') do
      subject.changed!

      expect(subject.changed?).to be(true)
    end
  end

  describe('#publish') do
    before { subject.instance_variable_get(:@plugins) << plugin }
    let(:plugin) { double('plugin') }

    it('skips over any plugins that are not subscribed to the event') do
      allow(plugin).to receive(:subscribed?).and_return(false)

      subject.publish(:foo)

      expect(subject).to_not receive(:publish)
    end

    it('publishes the event on any listening plugins') do
      allow(plugin).to receive(:subscribed?).and_return(true)
      expect(plugin).to receive(:publish).with(:foo, :bar, :lux).and_return(true)

      subject.publish(:foo, :bar, :lux)
    end

    it('returns false early if any of the plugin publish calls return false') do
      next_plugin = double('next plugin')
      subject.instance_variable_get(:@plugins) << next_plugin
      allow(plugin).to receive(:subscribed?).and_return(true)
      expect(plugin).to receive(:publish).and_return(false)

      expect(subject.publish(:foo)).to be(false)
      expect(next_plugin).to_not receive(:subscribed?)
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
        config: {},
        parents: []
      }.inspect)
    end
  end
end
