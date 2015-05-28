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

    desc 'projects [--tags TAG,TAG,...]', 'tasks.projects.desc'
    option :tags, type: :array, desc: 'tasks.common.options.tags'
    def projects(options)
      filtered_projects(options).each { |project| puts project }
    end

    desc 'build [--tags TAG,TAG,...]', 'tasks.build.desc'
    option :tags, type: :array, desc: 'tasks.common.options.tags'
    def build(options)
      run_common_task(options, :build)
    end

    desc 'test [--tags TAG,TAG,...]', 'tasks.test.desc'
    option :tags, type: :array, desc: 'tasks.common.options.tags'
    def test(options)
      run_common_task(options, :test)
    end

    private

    def run_common_task(options, task)
      filtered_projects(options).each do |project|
        fail I18n.t("tasks.#{task}.failed", project: project) unless project.publish(task)
      end
    end

    def filtered_projects(options)
      return graph.all_with_tags(*options.tags.split(',')) unless options.tags.nil?
      graph
    end

    def graph
      if Dir.pwd == task_env.root
        task_env.graph
      else
        task_env.graph.projects_within_path(Dir.pwd)
      end
    end
  end
end
