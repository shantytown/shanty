require 'commander'
require 'i18n'
require 'shanty/task'

module Shanty
  # Public: Handle the CLI interface between the user and the registered tasks
  # and plugins.
  class Cli
    include Commander::Methods

    def initialize(graph)
      @graph = graph
    end

    def tasks
      Task.tasks.reduce({}) do |acc, task|
        acc.merge(task.task_definitions)
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
      command name do |c|
        c.description = I18n.t(task[:desc], default: task[:desc])

        task[:options].each do |option_name, option|
          c.option(syntax_for_option(option_name, option), I18n.t(option[:desc], default: option[:desc]))
        end

        c.action do |args, options|
          execute_task(name, args, options)
        end
      end
    end

    def execute_task(name, args, options)
      task = tasks[name]

      default_option_pairs = task[:options].map do |option_name, option|
        [option_name, default_for_type(option)]
      end
      options.default(Hash[default_option_pairs])

      task[:klass].new.send(name, options, @graph, *args)
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
