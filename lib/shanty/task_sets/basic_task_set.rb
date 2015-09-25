require 'fileutils'
require 'i18n'
require 'shanty/task_set'
require 'shanty/plugin'

module Shanty
  # Public: A set of basic tasks that can be applied to all projects and that
  # ship with the core of Shanty.
  class BasicTasks < TaskSet
    desc 'init', 'tasks.init.desc'
    def init
      FileUtils.touch(File.join(Dir.pwd, '.shanty.yml'))
    end

    desc 'plugins', 'tasks.plugins.desc'
    def plugins(_)
      Plugin.plugins.each do |plugin|
        puts plugin.class.name
      end
    end

    desc 'projects [--tags TAG,TAG,...]', 'tasks.projects.desc'
    option :tags, type: :array, desc: 'tasks.common.options.tags'
    def projects(options)
      filtered_graph(*tags_from_options(options)).each do |project|
        puts "#{project.name} (#{project.path})#{project.tags.map { |tag| "\n  - #{tag}" }.join}"
      end
    end

    desc 'build [--tags TAG,TAG,...]', 'tasks.build.desc'
    option :tags, type: :array, desc: 'tasks.common.options.tags'
    def build(options)
      run_common_task(:build, *tags_from_options(options))
    end

    desc 'test [--tags TAG,TAG,...]', 'tasks.test.desc'
    option :tags, type: :array, desc: 'tasks.common.options.tags'
    def test(options)
      run_common_task(:test, *tags_from_options(options))
    end

    private

    def tags_from_options(options)
      (options.tags || '').split(',')
    end

    def run_common_task(task, *tags)
      filtered_graph(*tags).each do |project|
        Dir.chdir(project.path) do
          fail I18n.t("tasks.#{task}.failed", project: project) unless project.publish(task)
        end
      end
    end

    def filtered_graph(*tags)
      return scoped_graph.all_with_tags(*tags) unless tags.empty?
      scoped_graph
    end

    def scoped_graph
      return graph if Dir.pwd == root
      graph.projects_within_path(Dir.pwd)
    end
  end
end
