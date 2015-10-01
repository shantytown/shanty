require 'i18n'
require 'pathname'
require 'shanty/cli'
require 'shanty/env'
require 'shanty/graph'
require 'shanty/graph_factory'

module Shanty
  # Main shanty class
  class Shanty
    # This is the root directory where the Shanty gem is located. Do not confuse this with the root of the repository
    # in which Shanty is operating, which is available via the TaskEnv class.
    GEM_ROOT = File.expand_path(File.join(__dir__, '..'))

    def initialize
      @env = Env.new
    end

    def start!
      setup_i18n
      execute_shantyconfig!
      Cli.new(@env.task_sets, @env, graph).run
    end

    private

    def execute_shantyconfig!
      config_path = File.join(@env.root, Env::CONFIG_FILE)
      @env.instance_eval(File.read(config_path), config_path)
    end

    def graph
      GraphFactory.new(@env).graph
    end

    def setup_i18n
      I18n.enforce_available_locales = true
      I18n.load_path = Dir[File.join(GEM_ROOT, 'translations', '*.yml')]
    end
  end
end
