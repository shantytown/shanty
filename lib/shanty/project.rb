require 'shanty/mixins/acts_as_link_graph_node'

# Public: Represents a project in the current repository.
module Shanty
  class Project
    include Mixins::ActsAsLinkGraphNode

    attr_accessor :name, :path, :options, :changed

    # Public: Initialise the Project instance.
    #
    # project_template - An instance of ProjectTemplate from which to
    #                    instantiate this project.
    def initialize(project_template)
      @name = project_template.name
      @path = project_template.path
      @options = project_template.options
      @changed = false

      project_template.plugins.each do |plugin|
        include plugin
      end

      self.instance_eval(&project_template.project_block) unless project_template.project_block.nil?
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
        path: path,
        options: options
      }.inspect
    end
  end
end
