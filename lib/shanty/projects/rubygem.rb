require 'shanty/project'

module Shanty
  # Public: Represents a projects created with the Ruby language.
  class RubygemProject < Project
    subscribe :build, :on_build

    def on_build
      system 'gem build *.gemspec'
    end
  end
end
