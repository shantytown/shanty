require 'bundler'
require 'shanty/plugin'

module Shanty
  # Public: Bundler plugin for building ruby projects.
  class BundlerPlugin < Plugin
    projects '**/Gemfile'
    subscribe :build, :bundle_install

    def bundle_install
      Bundler.with_clean_env do
        # FIXME: Add support for the --jobs argument to parallelise the bundler run.
        system 'bundle install --quiet'
      end
    end
  end
end
