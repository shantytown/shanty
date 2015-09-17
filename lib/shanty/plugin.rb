require 'shanty/env'
require 'shanty/project'

module Shanty
  # Some basic functionality for every plugin.
  module Plugin
    include Env

    def self.extended(plugin)
      plugins << plugin
    end

    def self.plugins
      @plugins ||= []
    end

    #

    def self.discover_all_projects # => [Project]
      plugins.flat_map(&:wanted_projects).uniq
    end

    def self.with_graph(graph)
      plugins.each do |plugin|
        plugin.with_graph_callbacks.each { |callback| callback.call(graph) }
      end
    end

    #

    def callbacks
      @callbacks ||= []
    end

    def tags
      @tags ||= []
    end

    def wanted_project_globs
      @wanted_project_globs ||= []
    end

    def wanted_project_callbacks
      @wanted_project_callbacks ||= []
    end

    def with_graph_callbacks
      @with_graph_callbacks ||= []
    end

    #

    def add_to_project(project)
      project.singleton_class.include(self)
      callbacks.each { |args| project.subscribe(*args) }
      tags.each { |tag| project.tag(tag) }
    end

    #

    def subscribe(*args)
      callbacks << args
    end

    def adds_tags(*args)
      tags.concat(args)
    end

    def wants_projects_matching(*globs, &block)
      wanted_project_globs.concat(globs)
      wanted_project_callbacks << block if block_given?
    end

    def with_graph(&block)
      with_graph_callbacks << block
    end

    #

    def wanted_projects
      (wanted_projects_from_globs + wanted_projects_from_callbacks).uniq.tap do |projects|
        projects.each do |project|
          project.plugin(self)
        end
      end
    end

    private

    def wanted_projects_from_globs
      wanted_project_globs.flat_map do |globs|
        # Will make the glob absolute to the root if (and only if) it is relative.
        project_tree.glob(File.expand_path(globs, root)).map do |path|
          Project.new(File.absolute_path(File.dirname(path)))
        end
      end
    end

    def wanted_projects_from_callbacks
      wanted_project_callbacks.flat_map(&:call)
    end
  end
end
