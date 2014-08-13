module Shanty
  # Public: Discover shanty plugins
  class Plugin
    class << self
      attr_reader :plugins
    end

    # This method is auto-triggred by Ruby whenever a class inherits from
    # Shanty::Plugin. This means we can build up a list of all the plugins
    # without requiring them to register with us - neat!
    def self.inherited(plugin)
      @plugins ||= []
      @plugins << plugin
    end
  end
end
