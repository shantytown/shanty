require 'shanty/plugin'

module Shanty
  class BundlerPlugin < Plugin
    before :build, :bundle_install

    def bundle_install
      `bundle install`
    end
  end
end
