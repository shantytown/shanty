require 'shanty/plugin'

module Shanty
  # Public: Bundler plugin for building ruby projects.
  module BundlerPlugin
    extend Plugin

    subscribe :build, :bundle_install

    def bundle_install
      `bundle install`
    end
  end
end
