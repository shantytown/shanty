require 'fileutils'
require 'i18n'
require 'shanty/task_set'

module Shanty
  # Public: A set of basic tasks that can be applied to all projects and that
  # ship with the core of Shanty.
  class BasicTasks < TaskSet
    desc 'init', 'tasks.init.desc'
    def init
      FileUtils.touch(File.join(Dir.pwd, '.shanty.yml'))
    end

    desc 'projects [--changed] [--types TYPE,TYPE,...]', 'tasks.projects.desc'
    option :changed, type: :boolean, desc: 'tasks.common.options.changed'
    option :types, type: :array, desc: 'tasks.common.options.types'
    def projects(options)
      task_env.graph.each do |project|
        next if options.changed && !project.changed?
        puts project
      end
    end

    desc 'build [--changed] [--with-plugin PLUGIN,PLUGIN,...]', 'tasks.build.desc'
    option :changed, type: :boolean, desc: 'tasks.common.options.changed'
    option :types, type: :array, desc: 'tasks.common.options.types'
    def build(options)
      run_common_task(options, :build)
    end

    desc 'test [--changed] [--types TYPE,TYPE,...]', 'tasks.test.desc'
    option :changed, type: :boolean, desc: 'tasks.common.options.changed'
    option :types, type: :array, desc: 'tasks.common.options.types'
    def test(options)
      run_common_task(options, :test)
    end

    private

    def run_common_task(options, task)
      projects_to_execute.each do |project|
        next if options.changed? && !project.changed?
        fail I18n.t("tasks.#{task}.failed", project: project) unless project.publish(task)
      end
    end

    def projects_to_execute
      if Dir.pwd == task_env.root
        task_env.graph
      else
        task_env.graph.projects_within_path(Dir.pwd)
      end
    end
  end
end
