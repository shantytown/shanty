require 'commander'
require 'i18n'
require 'shanty/info'
require 'shanty/task_env'
require 'shanty/task_set'

module Shanty
  # Public: Handle the CLI interface between the user and the registered tasks
  # and plugins.
  class Cli
    include Commander::Methods

    attr_reader :env, :task_sets

    def initialize(env, task_sets)
      @env = env
      @task_sets = task_sets
    end

    def task_env
      @task_env ||= TaskEnv.new(@env)
    end

    def tasks
      @tasks ||= task_sets.reduce({}) do |acc, task_set|
        # FIXME: Warn or fail when there are duplicate task names?
        acc.merge(task_set.tasks)
      end
    end

    def run
      program(:name, 'Shanty')
      program(:version, Info::VERSION)
      program(:description, Info::DESCRIPTION)

      setup_tasks
      run!
    end

    private

    def setup_tasks
      tasks.each do |name, task|
        setup_task(name, task)
      end
    end

    def setup_task(name, task)
      command(name) do |c|
        c.description = I18n.t(task[:desc], default: task[:desc])
        c.syntax = task[:syntax]
        add_options_to_command(task, c)
        add_action_to_command(name, task, c)
      end
    end

    def add_options_to_command(task, command)
      task[:options].each do |option_name, option|
        command.option(syntax_for_option(option_name, option), I18n.t(option[:desc], default: option[:desc]))
      end
    end

    def add_action_to_command(name, task, command)
      command.action do |_, options|
        task = tasks[name]
        options.default(Hash[defaults_for_options(task)])
        execute_task(name, task, options)
      end
    end

    def execute_task(name, task, options)
      klass = task[:klass].new(task_env)
      arity = klass.method(name).arity
      args = (arity >= 1 ? [options] : [])
      klass.send(name, *args)
    end

    def defaults_for_options(task)
      task[:options].map do |option_name, option|
        [option_name, default_for_type(option)]
      end
    end

    def syntax_for_option(name, option)
      required = option[:required]
      case option[:type]
      when :boolean
        "--#{name}"
      else
        "--#{name} #{'[' unless required}#{name.upcase}#{']' unless required}"
      end
    end

    def default_for_type(option)
      case option[:type]
      when :boolean
        option[:default] || false
      else
        option[:default]
      end
    end
  end
end
