require_relative 'project'

class Shanty::Project::StaticProject < Shanty::Project
  # Public: A string representation of the type of the current Project subclass.
  # This is expected to be overriden in subclasses.
  #
  # Returns a String representation of the type of this Project.
  def type
    'static'
  end

  # Public: The absolute path to the artifact that would be created by this
  # project when built.
  #
  # Returns a String representing the absolute path to the artifact.
  def artifact_path
    "#{@root_dir}/build/#{@options['artifact_name'] || name}-#{@build_number}.tgz"
  end
end
