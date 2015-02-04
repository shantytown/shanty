require 'shanty/project'

module Shanty
  # Public: Base type of project, simply creates a tarball of the directory
  class StaticProject < Project
    subscribe :build, :tar_project

    def tar_project
      # FIXME: Create a tarball of the current project.
      system "tar -czvf #{artifact_paths.first} ."
    end

    def artifact_paths
      [
        File.join(@env.root, 'build', "#{@options['artifact_name'] || @name}-#{@env.build_number}.tar.gz")
      ]
    end
  end
end
