require 'i18n'
require 'pathname'
require 'pry'

require 'shanty/cli'
require 'shanty/env'
require 'shanty/graph'

# Require all plugins and task sets.
Dir[File.join(__dir__, 'shanty', '{plugins,task_sets}', '*.rb')].each { |f| require f }

module Shanty
  # Main shanty class
  class Shanty
    # This is the root directory where the Shanty gem is located. Do not confuse this with the root of the repository
    # in which Shanty is operating, which is available via the TaskEnv class.
    GEM_ROOT = File.expand_path(File.join(__dir__, '..'))

    def start!
      setup_i18n
      Cli.new(env, TaskSet.task_sets).run
    end

    private

    def setup_i18n
      I18n.enforce_available_locales = true
      I18n.load_path = Dir[File.join(GEM_ROOT, 'translations', '*.yml')]
    end

    def env
      Env.new.tap(&:require!)
    end
  end
end
