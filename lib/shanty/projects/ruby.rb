require 'shanty/project'

module Shanty
  # Public: Base type of project, simply creates a tarball of the directory
  class RubyProject < Project
    subscribe :build, :on_build

    def on_build
    end
  end
end
