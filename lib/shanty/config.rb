require 'shenanigans/hash/to_ostruct'
require 'deep_merge'

module Shanty
  # Public: Configuration class for shanty
  class Config
    CONFIG_FILE = '.shanty.yml'

    def initialize(root, environment)
      @root = root
      @environment = environment
    end

    def merge!(new_config)
      @config = config_hash.clone.deep_merge(new_config)
    end

    def [](key)
      to_ostruct[key]
    end

    def method_missing(m)
      os_resp = to_ostruct.send(m)
      return os_resp unless os_resp.nil?
      OpenStruct.new
    end

    def respond_to?(method_sym, include_private = false)
      to_ostruct.send.respond_to?(method_sym, include_private)
    end

    def to_ostruct
      config_hash.to_ostruct
    end

    private

    def config_hash
      return @config unless @config.nil?
      return @config = {} unless File.exist?(config_path)
      config = YAML.load_file(config_path) || {}
      @config = config[@environment] || {}
    rescue RuntimeError
      {}
    end

    def config_path
      "#{@root}/#{CONFIG_FILE}"
    end
  end
end
