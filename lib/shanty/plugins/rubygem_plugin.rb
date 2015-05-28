require 'shanty/plugin'

module Shanty
  # Public: Rubygem plugin for buildin gems.
  module RubygemPlugin
    extend Plugin

    wants_projects_matching '**/*.gemspec'
    subscribe :build, :build_gem

    def build_gem
      system 'gem build *.gemspec'
    end
  end
end
