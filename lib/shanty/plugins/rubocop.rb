require 'shanty/plugin'

module Shanty
  # Public: Rubocop plugin for style checking ruby projects.
  module RubocopPlugin
    extend Plugin

    subscribe :test, :rubocop

    def rubocop
      system 'rubocop'
    end
  end
end
