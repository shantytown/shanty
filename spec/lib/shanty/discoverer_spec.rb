require 'shanty/discoverer'

# All classes referenced belong to the shanty project
module Shanty
  RSpec.describe Shanty::Discoverer do
    let(:discoverers) do
      Discoverer.discoverers
    end

    describe '#discoervers' do
      it 'finds all discoverers' do
        expect(discoverers).to contain_exactly(Shanty::ShantyfileDiscoverer)
        expect(discoverers.size).to be == 1
      end
    end
  end
end
