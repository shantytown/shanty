require 'call_me_ruby'
require 'shanty/config'
require 'shanty/config_mixin'
require 'shanty/plugin_dsl'
require 'shanty/project'

module Shanty
  # Some basic functionality for every plugin.
  class Plugin
    include CallMeRuby
    extend ConfigMixin
    extend PluginDsl

    attr_reader :project, :env

    def initialize(project, env)
      @project = project
      @env = env
    end

    # External getters
    def self.project_providers
      @project_providers ||= []
    end

    def self.project_globs
      @project_globs ||= []
    end

    def self.tags
      @tags ||= [name]
    end

    def self.name
      to_s.split('::').last.downcase.gsub('plugin', '').to_sym
    end

    def self.info
      {
        name: name,
        description: @description,
        tags: tags,
        subscribes: class_callbacks.keys,
        config: config
      }
    end

    # Outside builders

    def self.projects(env)
      Set.new.tap do |projects|
        projects.merge(project_providers.flat_map { |provider| send(provider, env) })
        env.file_tree.glob(*project_globs).each do |path|
          projects << find_or_create_project(File.dirname(path), env)
        end

        projects.each { |project| project.add_plugin(self) }
      end
    end

    # Inner class methods
    def self.find_or_create_project(path, env)
      path = File.absolute_path(path)
      (env.projects[path] ||= Project.new(path, env))
    end

    def artifacts
      []
    end

    def config
      @config ||= Config.new(project.config[self.class.name], env.config[self.class.name], self.class.config)
    end
  end
end
