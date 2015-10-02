require 'active_support/core_ext/hash/indifferent_access'
require 'spec_helper'
require 'shanty/plugin'
require 'shanty/plugin_dsl'

RSpec.describe(Shanty::PluginDsl) do
  include_context('workspace')

  subject { Class.new(Shanty::Plugin) }

  describe('.description') do
    it('stores a plugin description') do
      subject.description('Nic Cage')

      expect(subject.instance_variable_get(:@description)).to eql('Nic Cage')
    end
  end

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

  describe('.provides_config') do
    it('can set a default value for a config key') do
      subject.provides_config(:nic, 'cage')

      expect(subject.config[:nic]).to eql('cage')
    end

    it('fails when supplied default is not a string') do
      expect { subject.provides_config(:nic, 1337) }.to raise_error('Default config value for key nic is not a string')
    end

    it('can set set an expectation for a config key') do
      subject.provides_config(:nic)

      expect(subject.config.key?(:nic)).to be(true)
      expect(subject.config[:nic]).to be_nil
    end
  end
end
