require 'shanty/plugin'

module Shanty
  module Plugins
    # Public: Rubocop plugin for style checking ruby projects.
    class RubocopPlugin < Plugin
      provides_projects_containing '**/.rubocop.yml'
      subscribe :test, :rubocop

      def rubocop
        system 'rubocop'
      end
    end
  end
end
