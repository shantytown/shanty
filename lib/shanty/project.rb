require 'acts_as_graph_vertex'
require 'call_me_ruby'
require 'shanty/config_mixin'
require 'shanty/logger'

module Shanty
  # Public: Represents a project in the current repository.
  class Project
    include ActsAsGraphVertex
    include ConfigMixin
    include Logger

    attr_accessor :path, :env, :name, :artifacts, :tags

    # Public: Initialise the Project instance.
    #
    # path - The path to the project.
    # env - The instance of the environment this project should have access to.
    def initialize(path, env)
      full_path = File.expand_path(path, env.root)
      fail('Path to project must be a directory.') unless File.directory?(full_path)

      @path = full_path
      @env = env

      @name = File.basename(full_path)
      # FIXME: When changed is implemented properly, redefine this to default
      # to false.
      @changed = true
      @artifacts = []
      @plugins = []
      @tags = []
    end

    def add_plugin(plugin)
      @plugins << plugin.new(self, env)
    end

    def remove_plugin(plugin_class)
      @plugins.delete_if { |plugin| plugin.is_a?(plugin_class) }
    end

    # Public: The tags assigned to this project, and any tags provided by any
    # plugins operating on this project.
    #
    # Returns an Array of symbols representing the tags on this project.
    def all_tags
      (@tags + @plugins.flat_map { |plugin| plugin.class.tags }).map(&:to_sym).uniq
    end

    # Public: The artifacts published by this project and any artifacts published
    # by any plugins operating on this project.
    #
    # Returns the Array of Artifacts available for this project.
    def all_artifacts
      (@artifacts + @plugins.flat_map { |plugin| plugin.artifacts(project) }).uniq
    end

    # Public: Whether this project is changed. Note that a project is considered
    # changed if any of its ancestors are marked as changed.
    #
    # Returns a boolean, true if the project is considered changed.
    def changed?
      @changed || parents.any?(&:changed?)
    end

    # Public: Mark this project as changed. Note that any decendants of this
    # project will also be marked as changed by setting this.
    def changed!
      @changed = true
    end

    def publish(name, *args)
      @plugins.each do |plugin|
        next unless plugin.subscribed?(name)
        logger.info("Executing #{name} on the #{plugin.class} plugin...")
        return false if plugin.publish(name, *args) == false
      end
    end

    # Public: Overriden String conversion method to return a simplified
    # representation of this instance that doesn't include the cyclic
    # parent/children attributes as defined by the ActsAsGraphVertex mixin.
    #
    # Returns a simple String representation of this instance.
    def to_s
      name
    end

    # Public: Overriden String conversion method to return a more detailed
    # representation of this instance that doesn't include the cyclic
    # parent/children attributes as defined by the ActsAsGraphVertex mixin.
    #
    # Returns more detailed String representation of this instance.
    def inspect
      {
        name: @name,
        path: @path,
        tags: all_tags,
        config: config,
        parents: parents.map(&:path)
      }.inspect
    end
  end
end
