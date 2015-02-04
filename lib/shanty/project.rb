require 'call_me_ruby'
require 'shanty/mixins/acts_as_graph_node'

module Shanty
  # Public: Represents a project in the current repository.
  class Project
    include Mixins::ActsAsGraphNode
    include CallMeRuby

    attr_accessor :name, :path, :options, :parents_by_path, :changed
    alias_method :changed?, :changed

    # Public: Initialise the Project instance.
    #
    # env              - The environment, an instance of Env.
    # project_template - An instance of ProjectTemplate from which to
    #                    instantiate this project.
    def initialize(env, project_template)
      @env = env
      @project_template = project_template
      @name = project_template.name
      @path = project_template.path
      @options = project_template.options
      @parents_by_path = project_template.parents
      @changed = false
    end

    def setup!
      @project_template.plugins.each do |plugin|
        plugin.add_to_project(self)
      end

      instance_eval(&@project_template.after_create) unless @project_template.after_create.nil?
    end

    # Public: The absolute paths to the artifacts that would be created by this
    # project when built, if any. This is expected to be overriden in subclasses.
    #
    # Returns an Array of Strings representing the absolute paths to the artifacts.
    def artifact_paths
      []
    end

    # Public: Overriden String conversion method to return a simplified
    # representation of this instance that doesn't include the cyclic
    # parent/children attributes as defined by the ActsAsGraphNode mixin.
    #
    # Returns a simple String representation of this instance.
    def to_s
      "Name: #{name}, Type: #{self.class}"
    end

    # Public: Overriden String conversion method to return a more detailed
    # representation of this instance that doesn't include the cyclic
    # parent/children attributes as defined by the ActsAsGraphNode mixin.
    #
    # Returns more detailed String representation of this instance.
    def inspect
      {
        name: @name,
        path: @path,
        options: @options,
        parents_by_path: @parents_by_path,
        changed: @changed
      }.inspect
    end

    def within_project_dir
      return unless block_given?

      Dir.chdir(path) do
        yield
      end
    end
  end
end
