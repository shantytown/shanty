require 'spec_helper'
require 'shanty/plugins/rubocop_plugin'

RSpec.describe(Shanty::Plugins::RubocopPlugin) do
  include_context('plugin')

  it('adds the rubocop tag automatically') do
    expect(described_class).to provide_tags(:rubocop)
  end

  it('finds projects that have a .rubocop.yml file') do
    expect(described_class).to provide_projects_containing('**/.rubocop.yml')
  end

  it('subscribes to the test event') do
    expect(described_class).to subscribe_to(:test).with(:rubocop)
  end

  describe('#rubocop') do
    it('calls rubocop') do
      expect(subject).to receive(:system).with('rubocop')

      subject.rubocop
    end
  end
end
