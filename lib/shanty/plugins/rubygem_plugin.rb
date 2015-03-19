require 'shanty/plugin'

module Shanty
  # Public: Rubygem plugin for buildin gems.
  module RubygemPlugin
    extend Plugin

    subscribe :build, :build_gem

    def build_gem
      system 'gem build *.gemspec'
    end
  end
end
