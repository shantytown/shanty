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
      filtered_graph(options).each { |project| puts project }
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
      filtered_graph(options).each do |project|
        Dir.chdir(project.path) do
          fail I18n.t("tasks.#{task}.failed", project: project) unless project.publish(task)
        end
      end
    end

    def filtered_graph(options)
      return scoped_graph.all_with_tags(*options.tags.split(',')) unless options.tags.nil?
      scoped_graph
    end

    def scoped_graph
      return graph if Dir.pwd == root
      graph.projects_within_path(Dir.pwd)
    end
  end
end
