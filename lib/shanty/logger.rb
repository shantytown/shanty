module Shanty
  # Small mixin that gives the receiver class a logger method. This method simply wraps the Ruby Logger class with a
  # nice consistent logging format.
  module Logger
    module_function

    def logger
      @logger ||= ::Logger.new($stdout).tap do |logger|
        logger.formatter = proc do |_, datetime, _, msg|
          "#{datetime}: #{msg}\n"
        end
      end
    end
  end
end
