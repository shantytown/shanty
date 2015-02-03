require 'spec_helper'
require 'shanty/discoverer'
require_fixture 'test_discoverer'

# All classes referenced belong to the shanty project
module Shanty
  RSpec.describe(Discoverer) do
    let(:discoverers) { Discoverer.discoverers }

    describe '#discoverers' do
      it 'finds discoverers' do
        expect(discoverers).to include(TestDiscoverer)
      end
    end
  end
end
