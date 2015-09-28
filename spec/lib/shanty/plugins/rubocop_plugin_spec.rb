require 'spec_helper'
require 'shanty/plugins/rubocop_plugin'

# All classes referenced belong to the shanty project
module Shanty
  RSpec.describe(RubocopPlugin) do
    include_context('graph')

    it('adds the rubocop tag automatically') do
      expect(described_class.tags).to match_array([:rubocop])
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

        subject.rubocop(project)
      end
    end
  end
end
