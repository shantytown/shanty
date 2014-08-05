require_relative 'mixins/acts_as_link_graph_node'

# Public: Represents a project in the current repository.
class Shanty::Project
  include ActsAsLinkGraphNode

  attr_accessor :name, :path, :current_branch, :root_dir, :build_number,
                :absolute_path, :options

  # Public: Initialise the Project instance.
  #
  # name           - The name of the current project.
  # path           - The path to the current project, relative to the root_dir.
  # current_branch - The current Git branch of the repository.
  # root_dir       - The root directory of the repository.
  # build_number   - The current build number.
  # options        - An optional Hash of parameter. This will be filled with any
  #                  extra fields found in the PROJECT_FILE for a project, and
  #                  subclasses may use specific fields found in here.
  def initialize(name, path, current_branch, root_dir, build_number, options = {})
    @name = name
    @path = path
    @current_branch = current_branch
    @root_dir = root_dir
    @build_number = build_number
    @options = options

    @absolute_path = File.join(root_dir, path)
  end

  # Public: Convenience method for creating an instance of a subclass of Project
  # using a String representation of the type.
  #
  # type  - The type to create, eg. docker, java, javascript.
  # *args - One or more arguments to pass to the constructor of the Project
  #         subclass.
  #
  # Returns an instance of the Project subclass.
  def self.create(type, *args)
    klass = const_get("#{type.capitalize}Project")
    klass.new(*args)
  end

  # Public: A string representation of the type of the current Project subclass.
  # This is expected to be overriden in subclasses.
  #
  # Returns a String representation of the type of this Project.
  def type
    'project'
  end

  # Public: Whether or not the current project is deployable. This is used to
  # determine whether artifacts need to be saved for this project.
  #
  # Returns a boolean representing whether the current project is deployable.
  def deployable?
    @options.include?('deployable') ? @options['deployable'] : true
  end

  # Public: A list of the dependencies this project has by name. This is used
  # as a precursor to building the links between project instances, whilst not
  # all of the Project instances are created. This is expected to be overriden
  # in subclasses where needed.
  #
  # Returns an Array of Strings representing parent projects by name only.
  def parents_by_name
    []
  end

  # Public: A list of the external dependencies this project has by name
  # and version. This is used in dependency tree generation.
  #
  #
  # Returns an Array of Strings representing external dependencies by name
  # and version.
  def externals_by_name
    []
  end

  # Public: The absolute path to the artifact that would be created by this
  # project when built, if any. This is expected to be overriden in subclasses.
  #
  # Returns a String representing the absolute path to the artifact.
  def artifact_path
    nil
  end

  # Public: Overriden String conversion method to return a simplified
  # representation of this instance that doesn't include the cyclic
  # parent/children attributes as defined by the ActsAsLinkGraphNode mixin.
  #
  # Returns a simple String representation of this instance.
  def to_s
    "Name: #{name}, Type: #{type}"
  end

  # Public: Overriden String conversion method to return a more detailed
  # representation of this instance that doesn't include the cyclic
  # parent/children attributes as defined by the ActsAsLinkGraphNode mixin.
  #
  # Returns more detailed String representation of this instance.
  def inspect
    {
      name: name,
      type: type,
      path: path,
      absolute_path: absolute_path,
      current_branch: current_branch
    }.inspect
  end
end
