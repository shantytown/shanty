require 'commander'
require 'i18n'
require 'shanty/info'
require 'shanty/task_set'
require 'shanty/env'

module Shanty
  # Public: Handle the CLI interface between the user and the registered tasks
  # and plugins.
  class Cli
    include Commander::Methods

    attr_reader :task_sets

    CONFIG_FORMAT = '[plugin]:[key] [value]'.freeze

    def initialize(task_sets, env, graph)
      @task_sets = task_sets
      @env = env
      @graph = graph
    end

    def tasks
      @tasks ||= task_sets.reduce({}) do |acc, task_set|
        # FIXME: Warn or raise when there are duplicate task names?
        acc.merge(task_set.tasks)
      end
    end

    def run
      program(:name, 'Shanty')
      program(:version, Info::VERSION)
      program(:description, Info::DESCRIPTION)

      setup_tasks
      global_config

      run!
    end

    private

    def global_config
      global_option('-c', '--config [CONFIG]', "Add config via command line in the format #{CONFIG_FORMAT}") do |config|
        # Disable using guards here because the line is too long otherwise if we do.
        # rubocop:disable Style/GuardClause
        if (match = config.match(/(?<plugin>\S+):(?<key>\S+)\s+(?<value>\S+)/))
          @env.config[match[:plugin].to_sym][match[:key].to_sym] = match[:value]
        else
          raise(I18n.t('cli.invalid_config_param', actual: config, expected: CONFIG_FORMAT))
        end
        # rubocop:enable Style/GuardClause
      end
    end

    def setup_tasks
      tasks.each do |name, task|
        setup_task(name, task)
      end
    end

    def setup_task(name, task)
      command(name) do |c|
        c.description = I18n.t(task[:desc], default: task[:desc])
        c.syntax = syntax_for_command(name, task)
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
        options.default(defaults_for_options(task).to_h)
        enforce_required_options(task, options)
        execute_task(name, task, options)
      end
    end

    def execute_task(name, task, options)
      klass = task[:klass].new(@env, @graph)
      arity = klass.method(name).arity
      args = (arity >= 1 ? [options] : [])
      klass.send(name, *args)
    end

    def defaults_for_options(task)
      task[:options].map do |option_name, option|
        [option_name, default_for_type(option)]
      end
    end

    def syntax_for_command(name, task)
      option_syntax = task[:options].map do |option_name, option|
        syntax_for_option(option_name, option)
      end

      [name, *option_syntax].join(' ')
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

    def enforce_required_options(task, options)
      missing = task[:options].keep_if do |option_name, option|
        option[:required] && options.__send__(option_name).nil?
      end.keys.join(', ')

      raise(I18n.t('cli.params_missing', missing: missing)) unless missing.empty?
    end
  end
end
