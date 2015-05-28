module Shanty
  # Some basic functionality for every plugin.
  module Plugin
    def self.extended(plugin)
      plugins << plugin
    end

    def self.plugins
      @plugins ||= []
    end

    def self.discover_all_projects(env) # => Hash[Path, Array[Plugin]] where Path = String, Plugin = Class
      projects = Hash.new { |h, k| h[k] = [] }
      plugins.each_with_object(projects) do |plugin, acc|
        paths = plugin.discover_projects(env) + plugin.wanted_projects(env)
        paths.each { |path| acc[path] << plugin }
      end
    end

    def self.with_graph(env, graph)
      plugins.each do |plugin|
        plugin.with_graph_callbacks.each { |callback| callback.call(env, graph) }
      end
    end

    def discover_projects(_env)
      []
    end

    def callbacks
      @callbacks ||= []
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

    def add_to_project(project)
      project.singleton_class.include(self)
      callbacks.each do |callback|
        project.subscribe(*callback)
      end
    end

    def subscribe(*args)
      callbacks << args
    end

    def wants_projects_matching(*globs, &block)
      wanted_project_globs.concat(globs)
      wanted_project_callbacks << block if block_given?
    end

    def with_graph(&block)
      with_graph_callbacks << block
    end

    def wanted_projects(env)
      (wanted_projects_from_globs(env) + wanted_projects_from_callbacks(env)).uniq
    end

    def execute_with_graph(env, graph)

    end

    private

    def wanted_projects_from_globs(env)
      wanted_project_globs.flat_map do |globs|
        # Will make the glob absolute to the root if (and only if) it is relative.
        Dir[File.expand_path(globs, env.root)].map do |path|
          File.absolute_path(File.dirname(path))
        end
      end
    end

    def wanted_projects_from_callbacks(env)
      wanted_project_callbacks.flat_map do |callback|
        callback.call(env).map do |path|
          File.absolute_path(File.dirname(path))
        end
      end
    end
  end
end
