require 'active_support/core_ext/hash/indifferent_access'
require 'shanty/config'

RSpec.describe(Shanty::Config) do
  subject { described_class.new(project_config, env_config, plugin_config) }

  describe('#[]') do
    let(:project_config) { HashWithIndifferentAccess.new }
    let(:env_config) { HashWithIndifferentAccess.new }
    let(:plugin_config) { HashWithIndifferentAccess.new }

    it('returns nothing when no config is present') do
      expect(subject[:nic]).to be_nil
    end

    it('returns default config in plugin') do
      plugin_config[:nic] = 'cage'

      expect(subject[:nic]).to eql('cage')
    end

    it('returns config in environment') do
      env_config[:nic] = 'cage'

      expect(subject[:nic]).to eql('cage')
    end

    it('returns config in project') do
      project_config[:nic] = 'cage'

      expect(subject[:nic]).to eql('cage')
    end

    it('overrides environment config with plugin config') do
      plugin_config[:nic] = 'copolla'
      env_config[:nic] = 'cage'

      expect(subject[:nic]).to eql('cage')
    end

    it('overrides environment config with project config') do
      env_config[:nic] = 'copolla'
      project_config[:nic] = 'cage'

      expect(subject[:nic]).to eql('cage')
    end

    it('overrides environment and plugin config with project config') do
      plugin_config[:nic] = 'kim'
      env_config[:nic] = 'copolla'
      project_config[:nic] = 'cage'

      expect(subject[:nic]).to eql('cage')
    end
  end
end
