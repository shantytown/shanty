require 'acts_as_graph_vertex'
require 'call_me_ruby'
require 'pathname'

require 'shanty/env'
require 'shanty/project_dsl'

module Shanty
  # Public: Represents a project in the current repository.
  class Project
    include ActsAsGraphVertex
    include Env
    include ProjectDsl

    attr_accessor :path, :parents_by_path

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
      pathname = Pathname.new(path)
      fail('Path to project must be a directory.') unless pathname.directory?
      fail('Path to project must be absolute.') unless pathname.absolute?

      @path = path

      @name = File.basename(path)
      @plugins = []
      @parents_by_path = []
      @tags = []
      @options = {}
    end

    def add_plugin(plugin)
      @plugins << plugin
    end

    def remove_plugin(plugin_class)
      @plugins.delete_if { |plugin| plugin.class == plugin_class }
    end

    def parent(parent)
      # Will make the parent path absolute to the root if (and only if) it is relative.
      @parents_by_path << File.expand_path(parent, root)
    end

    def tags
      (@tags + @plugins.flat_map { |plugin| plugin.class.tags }).uniq
    end

    def publish(name, *args)
      @plugins.each do |plugin|
        next unless plugin.subscribed?(name)
        puts "Executing #{name} on the #{plugin.class} plugin..."
        plugin.publish(name, *args)
      end
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
    # parent/children attributes as defined by the ActsAsGraphVertex mixin.
    #
    # Returns a simple String representation of this instance.
    def to_s
      "#{name} (#{path})\n  - #{tags.join("\n  - ")}"
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
        tags: @tags,
        options: @options,
        parents_by_path: @parents_by_path
      }.inspect
    end
  end
end
