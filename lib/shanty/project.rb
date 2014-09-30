require 'shanty/mixins/acts_as_link_graph_node'

module Shanty
  # Public: Represents a project in the current repository.
  class Project
    include Mixins::ActsAsLinkGraphNode

    attr_accessor :name, :path, :options, :parents_by_name, :changed
    attr_reader :changed
    alias_method :changed?, :changed

    # Public: Initialise the Project instance.
    #
    # project_template - An instance of ProjectTemplate from which to
    #                    instantiate this project.
    def initialize(project_template)
      @name = project_template.name
      @path = project_template.path
      @options = project_template.options
      @parents_by_name = project_template.parents
      @changed = false

      project_template.plugins.each do |plugin|
        include plugin
      end

      instance_eval(&project_template.after_create) unless project_template.after_create.nil?
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
      "Name: #{name}"
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
