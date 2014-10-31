require 'shanty/project'

module Shanty
  # Public: Base type of project, simply creates a tarball of the directory
  class StaticProject < Project
    subscribe :build, :on_build

    def on_build
      # FIXME: Create a tarball of the current project.
      true
    end

    # Public: The absolute path to the artifact that would be created by this
    # project when built.
    #
    # Returns a String representing the absolute path to the artifact.
    def artifact_path
      "#{@root_dir}/build/#{@options['artifact_name'] || name}-#{@build_number}.tgz"
    end
  end
end
