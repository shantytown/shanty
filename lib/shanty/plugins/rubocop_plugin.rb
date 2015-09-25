require 'shanty/plugin'

module Shanty
  # Public: Rubocop plugin for style checking ruby projects.
  class RubocopPlugin < Plugin
    projects '**/.rubocop.yml'
    subscribe :test, :rubocop

    def rubocop(_)
      system 'rubocop'
    end
  end
end
