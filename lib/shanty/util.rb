require 'logger'

module Shanty
  # Utility module for common tasks
  module Util
    module_function

    def logger
      @logger ||= Logger.new(STDOUT)
    end
  end
end
