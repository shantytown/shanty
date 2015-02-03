require 'shanty/project'

module Shanty
  # Public: Represents a projects created with the Ruby language.
  class RubygemProject < Project
    subscribe :build, :build_gem

    def build_gem
      system 'gem build *.gemspec'
    end
  end
end
