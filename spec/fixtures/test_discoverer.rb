require 'shanty/discoverer'

module Shanty
  # Test Discoverer fixture.
  class TestDiscoverer < Discoverer
    def discover
      []
    end
  end
end
