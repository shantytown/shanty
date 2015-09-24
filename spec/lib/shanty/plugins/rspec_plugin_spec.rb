require 'spec_helper'
require 'shanty/plugins/rspec_plugin'

# All classes referenced belong to the shanty project
module Shanty
  RSpec.describe(RspecPlugin) do
    include_context('basics')

    it('subscribes to the test event') do
      expect(RspecPlugin.instance_variable_get(:@class_callbacks)).to include(test: [:rspec])
    end

    describe('#rspec') do
      it('calls rspec') do
        expect(subject).to receive(:system).with('rspec')

        subject.rspec
      end
    end
  end
end
