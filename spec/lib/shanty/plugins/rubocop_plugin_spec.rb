require 'spec_helper'
require 'shanty/plugins/rubocop_plugin'

# All classes referenced belong to the shanty project
module Shanty
  RSpec.describe(RubocopPlugin) do
    include_context('basics')

    it('adds the rubocop tag') do
      expect(described_class).to add_tags(:rubocop)
    end

    it('finds projects that have a .rubocop.yml file') do
      expect(described_class).to define_projects.with('**/.rubocop.yml')
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
end
