require 'acts_as_graph_vertex'
require 'call_me_ruby'
require 'pathname'

require 'shanty/env'

module Shanty
  # Public: Represents a project in the current repository.
  class Project
    include ActsAsGraphVertex
    include Env

    attr_accessor :artifacts, :name, :path, :tags, :options

    # Multiton or Flyweight pattern - only allow once instance per unique path.
    #
    # See https://en.wikipedia.org/wiki/Multiton_pattern, http://en.wikipedia.org/wiki/Flyweight_pattern, or
    # http://blog.rubybestpractices.com/posts/gregory/059-issue-25-creational-design-patterns.html for more information.
    #
    # Note that this is _not_ currently threadsafe.
    class << self
      alias_method :__new__, :new

      def new(path)
        (@instances ||= {})[path] ||= __new__(path)
      end

      def clear!
        @instances = {}
      end
    end

    # Public: Initialise the Project instance.
    #
    # path - The path to the project.
    def initialize(path)
      pathname = Pathname.new(File.expand_path(path, root))
      fail('Path to project must be a directory.') unless pathname.directory?

      @path = path

      @name = File.basename(path)
      # FIXME: When changed is implemented properly, redefine this to default
      # to false.
      @changed = true
      @artifacts = []
      @plugins = []
      @tags = []
      @options = {}
    end

    def add_plugin(plugin)
      @plugins << plugin
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
        return false if plugin.publish(name, self, *args) == false
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
        options: @options,
        parents: parents.map(&:path)
      }.inspect
    end
  end
end
