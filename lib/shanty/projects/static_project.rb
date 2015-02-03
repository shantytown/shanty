require 'shanty/project'

module Shanty
  # Public: Base type of project, simply creates a tarball of the directory
  class StaticProject < Project
    subscribe :build, :tar_project

    def tar_project
      # FIXME: Create a tarball of the current project.
      true
    end

    # Public: The absolute path to the artifact that would be created by this
    # project when built.
    #
    # Returns a String representing the absolute path to the artifact.
    def artifact_path
      File.join(@env.root, 'build', "#{@options['artifact_name'] || @name}-#{@env.build_number}.tar.gz")
    end
  end
end
