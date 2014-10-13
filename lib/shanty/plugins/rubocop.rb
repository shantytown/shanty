require 'shanty/plugin'

module Shanty
  # Public: Rubocop plugin for style checking Ruby projects.
  class RubocopPlugin < Plugin
    before :test, :rubocop

    def rubocop
      `rubocop`
    end
  end
end
