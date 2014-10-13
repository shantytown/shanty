require 'shanty/plugin'

module Shanty
  # Public: Bundler plugin for building ruby projects.
  class BundlerPlugin < Plugin
    before :build, :bundle_install

    def bundle_install
      `bundle install`
    end
  end
end
