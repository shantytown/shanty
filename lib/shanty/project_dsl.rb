require 'attr_combined_accessor'

module Shanty
  # A container for the DSL exposed to Shantyfiles.
  module ProjectDsl
    attr_combined_accessor :name, :tags, :options

    def option(key, value)
      @options[key] = value
    end

    def tag(tag)
      @tags << tag
    end
  end
end
