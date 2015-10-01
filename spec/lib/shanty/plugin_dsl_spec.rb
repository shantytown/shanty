require 'spec_helper'
require 'shanty/plugin'
require 'shanty/plugin_dsl'

RSpec.describe(Shanty::PluginDsl) do
  include_context('workspace')

  subject { Class.new(Shanty::Plugin) }

  describe('.provides_projects') do
    it('stores the given symbols') do
      subject.provides_projects(:foo, :bar)

      expect(subject.instance_variable_get(:@project_providers)).to contain_exactly(:foo, :bar)
    end
  end

  describe('.provides_projects_containing') do
    it('stores the given globs') do
      subject.provides_projects_containing('**/foo', '**/bar')

      expect(subject.instance_variable_get(:@project_globs)).to contain_exactly('**/foo', '**/bar')
    end
  end

  describe('.provides_tags') do
    before do
      allow(subject).to receive(:name).and_return(:plugin_name)
    end

    it('stores the given tags') do
      subject.provides_tags(:foo, :marbles)

      expect(subject.instance_variable_get(:@tags)).to contain_exactly(:plugin_name, :foo, :marbles)
    end

    it('converts any given tags to symbols') do
      subject.provides_tags('bar', 'lux')

      expect(subject.instance_variable_get(:@tags)).to contain_exactly(:plugin_name, :bar, :lux)
    end
  end
end
