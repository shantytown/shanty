require 'shanty/plugin'

module Shanty
  # Test Plugin fixture.
  class TestPlugin < Plugin
    tags :test
    subscribe :foo, :bar
    subscribe :cats, :dogs, :rabies

    def bar; end

    def dogs; end

    def rabies; end
  end
end
