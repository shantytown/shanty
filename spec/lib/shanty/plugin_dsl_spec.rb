require 'active_support/core_ext/hash/indifferent_access'
require 'spec_helper'
require 'shanty/plugin'
require 'shanty/plugin_dsl'

RSpec.describe(Shanty::PluginDsl) do
  include_context('with tmp shanty')

  subject(:plugin_dsl) { Class.new(Shanty::Plugin) }

  describe('.description') do
    it('stores a plugin description') do
      plugin_dsl.description('Nic Cage')

      expect(plugin_dsl.instance_variable_get(:@description)).to eql('Nic Cage')
    end
  end

  describe('.provides_projects') do
    it('stores the given symbols') do
      plugin_dsl.provides_projects(:foo, :bar)

      expect(plugin_dsl.instance_variable_get(:@project_providers)).to contain_exactly(:foo, :bar)
    end
  end

  describe('.provides_projects_containing') do
    it('stores the given globs') do
      plugin_dsl.provides_projects_containing('**/foo', '**/bar')

      expect(plugin_dsl.instance_variable_get(:@project_globs)).to contain_exactly('**/foo', '**/bar')
    end
  end

  describe('.provides_tags') do
    before do
      allow(subject).to receive(:name).and_return(:plugin_name)
    end

    it('stores the given tags') do
      plugin_dsl.provides_tags(:foo, :marbles)

      expect(plugin_dsl.instance_variable_get(:@tags)).to contain_exactly(:plugin_name, :foo, :marbles)
    end

    it('converts any given tags to symbols') do
      plugin_dsl.provides_tags('bar', 'lux')

      expect(plugin_dsl.instance_variable_get(:@tags)).to contain_exactly(:plugin_name, :bar, :lux)
    end
  end

  describe('.provides_config') do
    it('can set a default value for a config key') do
      plugin_dsl.provides_config(:nic, 'cage')

      expect(plugin_dsl.config[:nic]).to eql('cage')
    end

    it('fails when supplied default is not a string') do
      expect do
        plugin_dsl.provides_config(:nic, 1337)
      end.to raise_error('Default config value for key nic is not a string')
    end

    it('can set set an expectation for a config key') do
      plugin_dsl.provides_config(:nic)

      expect(plugin_dsl.config.key?(:nic)).to be(true)
      expect(plugin_dsl.config[:nic]).to be_nil
    end
  end
end
