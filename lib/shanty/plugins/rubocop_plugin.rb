require 'shanty/plugin'

module Shanty
  # Public: Rubocop plugin for style checking ruby projects.
  module RubocopPlugin
    extend Plugin

    wants_projects_matching '**/.rubocop.yml'
    subscribe :test, :rubocop

    def rubocop
      system 'rubocop'
    end
  end
end
