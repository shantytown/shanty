require 'shanty/plugin'

module Shanty
  # Test unused Plugin fixture, used for testing whether looking plugins up by this plugin type, given none of them
  # have it included, returns nothing.
  class UnusedPlugin < Plugin; end
end
