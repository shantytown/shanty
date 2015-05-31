require 'shanty/plugin'

module Shanty
  # Public: Bundler plugin for building ruby projects.
  module BundlerPlugin
    extend Plugin

    adds_tags :bundler
    wants_projects_matching '**/Gemfile'
    subscribe :build, :bundle_install

    def bundle_install
      # FIXME: Add support for the --jobs argument to parallelise the bundler run.
      system 'bundle install --quiet'
    end
  end
end
