require 'shanty/util'
require 'shanty/project_template'

module Shanty
  # Some basic functionality for every plugin.
  module Plugin
    def self.extended(mod)
      mod.module_eval do
        def self.included(cls)
          copy_subscribes_to_class(cls)
        end
      end
    end

    def copy_subscribes_to_class(cls)
      @subscriptions.each do |args|
        cls.subscribe(*args)
      end
    end

    def subscribe(*args)
      @subscriptions ||= []
      @subscriptions.push(args)
    end
  end
end
