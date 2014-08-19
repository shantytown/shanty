require 'yaml'
require 'deep_merge'

module Shanty
  # Global configuration variables for shanty
  module Global
    module_function

    def config_file
      '.shanty.yml'
    end

    def environment
      @environment = ENV['SHANTY_ENV'] || 'local'
    end

    def default_config
      @default_config ||= {}
    end

    def add_default_config(new_config)
      @default_config.merge!(new_config)
    end

    def root
      @root ||= find_root
    end

    def config
      file_config = YAML.load_file("#{root}/#{config_file}") || {}
      @config ||= default_config.deep_merge!(file_config[environment]) || default_config
    end

    def find_root
      if root_dir.nil?
        fail "Could not find a #{Global.config_file} file in this or any parent directories. \
             Please run `shanty init` in the directory you want to be the root of your project structure."
      end
      root_dir
    end

    def root_dir
      Pathname.new(Dir.pwd).ascend do |d|
        return d if d.join(Global.config_file).exist?
      end
    end
  end
end
