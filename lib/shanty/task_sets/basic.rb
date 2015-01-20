require 'i18n'
require 'shanty/task_set'
require 'shanty/util'

module Shanty
  # Public: A set of basic tasks that can be applied to all projects and that
  # ship with the core of Shanty.
  class BasicTasks < TaskSet
    desc 'init', 'tasks.init.desc'
    def init(_options, _task_env)
      # FIXME
    end

    desc 'projects [--changed] [--types TYPE,TYPE,...]', 'tasks.projects.desc'
    option :changed, type: :boolean, desc: 'tasks.common.options.changed'
    option :types, type: :array, desc: 'tasks.common.options.types'
    def projects(options, task_env)
      task_env.graph.each do |project|
        next if options.changed? && !project.changed?
        puts project
      end
    end

    desc 'build [--changed] [--watch] [--types TYPE,TYPE,...]', 'tasks.build.desc'
    option :changed, type: :boolean, desc: 'tasks.common.options.changed'
    option :watch, type: :boolean, desc: 'tasks.common.options.watch'
    option :types, type: :array, desc: 'tasks.common.options.types'
    def build(options, task_env)
      task_env.graph.each do |project|
        next if options.changed? && !project.changed?
        fail I18n.t('tasks.build.failed', project: project) unless project.publish(:build)
      end
    end

    desc 'test [--changed] [--watch] [--types TYPE,TYPE,...]', 'tasks.test.desc'
    option :changed, type: :boolean, desc: 'tasks.common.options.changed'
    option :watch, type: :boolean, desc: 'tasks.common.options.watch'
    option :types, type: :array, desc: 'tasks.common.options.types'
    def test(options, task_env)
      task_env.graph.each do |project|
        next if options.changed? && !project.changed?
        fail I18n.t('tasks.test.failed', project: project) unless project.publish(:test)
      end
    end
  end
end
