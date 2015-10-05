require 'erubis'
require 'fileutils'
require 'i18n'
require 'shanty/task_set'
require 'shanty/plugin'

module Shanty
  module TaskSets
    # Public: A set of basic tasks that can be applied to all projects and that
    # ship with the core of Shanty.
    class BasicTaskSet < TaskSet
      desc 'init', 'tasks.init.desc'
      def init
        FileUtils.touch(File.join(Dir.pwd, '.shanty.yml'))
      end

      desc 'plugins', 'tasks.plugins.desc'
      def plugins(_)
        env.plugins.each do |plugin|
          puts plugin.name
        end
      end

      desc 'plugin [--name PLUGIN]', 'tasks.plugin.desc'
      option :name, desc: 'tasks.plugin.options.names'
      def plugin(options)
        plugin = plugin_index[options.name]

        fail I18n.t('tasks.plugin.failed', plugins: env.plugins.map(&:name).join(', ')) if plugin.nil?
        print_plugin_info(info)
      end

      desc 'projects [--tags TAG,TAG,...]', 'tasks.projects.desc'
      option :tags, type: :array, desc: 'tasks.common.options.tags'
      def projects(options)
        filtered_graph(*tags_from_options(options)).each do |project|
          puts "#{project.name} (#{project.path})#{project.all_tags.map { |tag| "\n  - #{tag}" }.join}"
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
        return graph if Dir.pwd == env.root
        graph.projects_within_path(Dir.pwd)
      end

      def plugin_index
        @plugin_index ||= env.plugins.each_with_object({}) do |plugin, acc|
          acc[plugin.name.to_s] = plugin
        end
      end

      def print_plugin_info(info)
        puts Erubis::Eruby.new(File.read(File.join(__dir__, 'plugin.erb'))).result(info)
      end
    end
  end
end
