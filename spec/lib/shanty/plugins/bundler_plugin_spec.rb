require 'spec_helper'
require 'shanty/plugins/bundler_plugin'

RSpec.describe(Shanty::Plugins::BundlerPlugin) do
  include_context('with plugin')

  it('adds the bundler tag automatically') do
    expect(described_class).to provide_tags(:bundler)
  end

  it('finds projects that have a Gemfile') do
    expect(described_class).to provide_projects_containing('**/Gemfile')
  end

  it('subscribes to the build event') do
    expect(described_class).to subscribe_to(:build).with(:bundle_install)
  end

  describe('#bundle_install') do
    it('calls bundler install') do
      expect(subject).to receive(:system).with('bundle install --quiet')

      subject.bundle_install
    end
  end
end
