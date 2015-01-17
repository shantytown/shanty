require 'i18n'
require 'pathname'
require 'pry'

require 'shanty/cli'
require 'shanty/discoverers/shantyfile'
require 'shanty/graph'
require 'shanty/mutators/git'
require 'shanty/task_env'
require 'shanty/task_sets/basic'

module Shanty
  # Main shanty class
  class Shanty
    # This is the root directory where the Shanty gem is located. Do not confuse this with the root of the repository
    # in which Shanty is operating, which is available via the TaskEnv class.
    GEM_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))

    def start!
      setup_i18n

      Cli.new(TaskEnv.new).run
    end

    private

    def setup_i18n
      I18n.enforce_available_locales = true
      I18n.load_path = Dir[File.join(GEM_ROOT, 'translations', '*.yml')]
    end
  end
end
