require 'i18n'
require 'shanty/task'
require 'shanty/util'

module Shanty
  # Public: A set of basic tasks that can be applied to all projects and that
  # ship with the core of Shanty.
  class BasicTasks < Shanty::Task
    desc 'tasks.projects.desc'
    option :changed, type: :boolean, desc: 'tasks.common.options.changed'
    option :types, type: :array, desc: 'tasks.common.options.types'
    def projects(options, graph)
      graph.projects.each do |project|
        next if options.changed? && !project.changed?
        puts project
      end
    end

    desc 'tasks.build.desc'
    option :changed, type: :boolean, desc: 'tasks.common.options.changed'
    option :watch, type: :boolean, desc: 'tasks.common.options.watch'
    option :types, type: :array, desc: 'tasks.common.options.types'
    def build(options, graph)
      graph.projects.each do |project|
        next if options.changed? && !project.changed?
        fail I18n.t('tasks.build.failed', project: project) unless project.publish(:build)
      end
    end

    desc 'tasks.test.desc'
    option :changed, type: :boolean, desc: 'tasks.common.options.changed'
    option :watch, type: :boolean, desc: 'tasks.common.options.watch'
    option :types, type: :array, desc: 'tasks.common.options.types'
    def test(options, graph)
      graph.projects.each do |project|
        next if options.changed? && !project.changed?
        fail I18n.t('tasks.test.failed', project: project) unless project.publish(:test)
      end
    end
  end
end
