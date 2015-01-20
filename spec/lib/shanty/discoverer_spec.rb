require 'spec_helper'

require 'shanty/discoverer'

# All classes referenced belong to the shanty project
module Shanty
  RSpec.describe Shanty::Discoverer do
    let(:discoverers) { Discoverer.discoverers }

    describe '#discoverers' do
      it 'finds all discoverers' do
        # FIXME: This is not a good test. This could break any time anything requires in another discoverer.
        # We should instead inspect that it contains a discoverer that we create and require within this test.
        expect(discoverers).to contain_exactly(Shanty::ShantyfileDiscoverer)
        expect(discoverers.size).to be == 1
      end
    end
  end
end
