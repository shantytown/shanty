require 'bundler'
require 'shanty/plugin'

module Shanty
  module Plugins
    # Public: Bundler plugin for building ruby projects.
    class BundlerPlugin < Plugin
      provides_projects_containing '**/Gemfile'
      subscribe :build, :bundle_install
      description 'Installs Rubygem dependencies for Ruby projects'

      def bundle_install
        Bundler.with_clean_env do
          # FIXME: Add support for the --jobs argument to parallelise the bundler run.
          system 'bundle install --quiet'
        end
      end
    end
  end
end
