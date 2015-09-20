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

    #

    # FIXME: Remove when the callbacks are being triggered across boundaries.
    # def add_to_project(project)
    #   project.singleton_class.include(self)
    #   callbacks.each do |args|
    #     project.subscribe(args.first) { puts "Executing #{args.first} on the #{self} plugin..." }
    #     project.subscribe(*args)
    #   end
    #   tags.each { |tag| project.tag(tag) }
    # end

    def self.tags(*args)
      @tags ||= []
      @tags.concat(args)
    end

    def self.projects(*globs_or_syms)
      @projects ||= []
      @projects.concat(globs_or_syms)
    end

    def self.with_graph(&block)
      @with_graph_callbacks ||= []
      @with_graph_callbacks << block
    end

    def projects
      projects = self.class.instance_variable_get(:@projects)
      return [] if projects.nil? || projects.empty?
      (projects_from_globs(projects) + projects_from_callbacks(projects)).uniq.tap do |projects|
        projects.each { |project| project.add_plugin(self) }
      end
    end

    def with_graph(graph)
      (@with_graph_callbacks || []).each { |callback| callback.call(graph) }
    end

    private

    def projects_from_globs(projects)
      globs = projects.find_all { |glob_or_sym| glob_or_sym.is_a?(String) }
      project_tree.glob(*globs).map { |path| Project.new(File.absolute_path(File.dirname(path))) }
    end

    def projects_from_callbacks(projects)
      projects.find_all { |glob_or_sym| glob_or_sym.is_a?(Symbol) }.flat_map { |sym| send(sym) }
    end
  end
end
