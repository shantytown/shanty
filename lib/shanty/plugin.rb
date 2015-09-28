require 'call_me_ruby'
require 'shanty/env'
require 'shanty/project'

module Shanty
  # Some basic functionality for every plugin.
  class Plugin
    include CallMeRuby
    include Env

    def self.inherited(plugin_class)
      @plugins ||= []
      @plugins << plugin_class.new
    end

    def self.all_projects
      (@plugins || []).flat_map(&:projects).uniq
    end

    def self.all_with_graph(graph)
      (@plugins || []).each { |plugin| plugin.with_graph(graph) }
    end

    def self.tags(*args)
      (@tags ||= []).concat(args.map(&:to_sym))
    end

    def self.projects(*globs_or_syms)
      (@project_matchers ||= []).concat(globs_or_syms)
    end

    def self.with_graph(&block)
      (@with_graph_callbacks ||= []) << block
    end

    def projects
      project_matchers = self.class.instance_variable_get(:@project_matchers)
      return [] if project_matchers.nil? || project_matchers.empty?
      (projects_from_globs(project_matchers) + projects_from_callbacks(project_matchers)).uniq.tap do |projects|
        projects.each { |project| project.add_plugin(self) }
      end
    end

    def artifacts(_)
      []
    end

    def with_graph(graph)
      callbacks = self.class.instance_variable_get(:@with_graph_callbacks)
      return [] if callbacks.nil? || callbacks.empty?
      callbacks.each { |callback| callback.call(graph) }
    end

    private

    def projects_from_globs(project_matchers)
      globs = project_matchers.find_all { |glob_or_sym| glob_or_sym.is_a?(String) }
      project_tree.glob(*globs).map { |path| Project.new(File.absolute_path(File.dirname(path))) }
    end

    def projects_from_callbacks(project_matchers)
      project_matchers.find_all { |glob_or_sym| glob_or_sym.is_a?(Symbol) }.flat_map { |sym| send(sym) }
    end
  end
end
