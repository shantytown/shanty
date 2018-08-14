require 'i18n'
require 'logger'
require 'pathname'
require 'shanty/config_mixin'
require 'shanty/file_tree'
require 'shanty/plugin'
require 'shanty/plugins/shantyfile_plugin'
require 'shanty/task_set'
require 'shanty/task_sets/basic_task_set'
require 'yaml'

module Shanty
  # RWS Monad pattern.
  class Env
    include ConfigMixin

    CONFIG_FILE = 'Shantyconfig'.freeze

    def root
      @root ||= find_root
    end

    def file_tree
      @file_tree ||= FileTree.new(root)
    end

    def plugins
      @plugins ||= [Plugins::ShantyfilePlugin]
    end

    def task_sets
      @task_sets ||= [TaskSets::BasicTaskSet]
    end

    def projects
      @projects ||= {}
    end

    def require(*args)
      new_plugins = []
      new_task_sets = []

      Plugin.send(:define_singleton_method, :inherited) { |klass| new_plugins << klass }
      TaskSet.send(:define_singleton_method, :inherited) { |klass| new_task_sets << klass }

      super(*args)

      Plugin.singleton_class.send(:remove_method, :inherited)
      TaskSet.singleton_class.send(:remove_method, :inherited)

      plugins.concat(new_plugins)
      task_sets.concat(new_task_sets)
    end

    private

    def find_root
      raise I18n.t('missing_root', config_file: CONFIG_FILE) if root_dir.nil?
      root_dir
    end

    def root_dir
      Pathname.new(Dir.pwd).ascend do |d|
        return d.to_s if d.join(CONFIG_FILE).exist?
      end
    end
  end
end
