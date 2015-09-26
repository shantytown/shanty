require 'shanty/plugin'

module Shanty
  # Public: Rubygem plugin for buildin gems.
  class RubygemPlugin < Plugin
    tags :rubygem
    projects '**/*.gemspec'
    subscribe :build, :build_gem

    def build_gem
      system 'gem build *.gemspec'
    end
  end
end
