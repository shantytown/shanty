require 'shanty/plugin'

module Shanty
  # Public: Rspec plugin for testing ruby projects.
  module RspecPlugin
    extend Plugin

    subscribe :test, :rspec

    def rspec
      system 'rspec'
    end
  end
end
