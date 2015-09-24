require 'spec_helper'
require 'shanty/plugins/rubocop_plugin'

# All classes referenced belong to the shanty project
module Shanty
  RSpec.describe(RubocopPlugin) do
    include_context('basics')

    it('subscribes to the test event') do
      expect(RubocopPlugin.instance_variable_get(:@class_callbacks)).to include(test: [:rubocop])
    end

    describe('#rubocop') do
      it('calls rubocop') do
        expect(subject).to receive(:system).with('rubocop')

        subject.rubocop
      end
    end
  end
end
