require 'commander'
require 'i18n'
require 'shanty/task_set'

module Shanty
  # Public: Handle the CLI interface between the user and the registered tasks
  # and plugins.
  class Cli
    include Commander::Methods

    def initialize(task_env)
      @task_env = task_env
    end

    def tasks
      TaskSet.task_sets.reduce({}) do |acc, task_set|
        acc.merge(task_set.tasks)
      end
    end

    def run
      program :name, 'Shanty'
      program :version, '0.1.0'
      program :description, 'Something'

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

        add_options_to_command(task, c)
        c.action do |args, options|
          task = tasks[name]
          options.default(Hash[defaults_for_options(task)])
          execute_task(name, task, args, options)
        end
      end
    end

    def add_options_to_command(task, command)
      task[:options].each do |option_name, option|
        command.option(syntax_for_option(option_name, option), I18n.t(option[:desc], default: option[:desc]))
      end
    end

    def execute_task(name, task, args, options)
      # We use allocate here beccause we do not want this to blow up because the class defines a constructor.
      # We cannot and do not support taskset classes needing constructors.
      klass = task[:klass].allocate
      arity = klass.method(name).arity

      args.unshift(@task_env) if arity >= 2
      args.unshift(options) if arity >= 1

      klass.send(name, *args)
    end

    def defaults_for_options(task)
      task[:options].map do |option_name, option|
        [option_name, default_for_type(option)]
      end
    end

    def syntax_for_option(name, option)
      syntax = case option[:type]
               when :boolean
                 "--#{name}"
               else
                 "--#{name} #{option[:type].upcase}"
               end

      option[:required] ? "[#{syntax}]" : syntax
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
