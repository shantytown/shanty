require 'shanty/plugin'

module Shanty
  # Test Plugin fixture.
  module TestPlugin
    extend Plugin

    add_tags :test
    subscribe :foo, :bar
    subscribe :cats, :dogs, :rabies

    def bar; end

    def rabies; end
  end
end
