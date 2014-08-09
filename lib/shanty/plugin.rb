module Shanty
  class Plugin
    @@plugins = []

    # This method is auto-triggred by Ruby whenever a class inherits from
    # Shanty::Plugin. This means we can build up a list of all the plugins
    # without requiring them to register with us - neat!
    def self.inherited(plugin)
      @@plugins << plugin
    end
  end
end
