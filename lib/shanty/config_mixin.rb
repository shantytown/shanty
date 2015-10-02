require 'active_support/core_ext/hash/indifferent_access'

module Shanty
  # Public: Config mixin for use with any class which is configurable
  module ConfigMixin
    def config
      @configuration ||= HashWithIndifferentAccess.new { |h, k| h[k] = HashWithIndifferentAccess.new }
    end
  end
end
