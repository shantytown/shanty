require 'logger'
require 'pathname'
require 'yaml'

module Shanty
  #
  class Env
    CONFIG_FILE = '.shanty.yml'

    def require!
      Dir.chdir(root) do
        (config['require'] || {}).each do |path|
          requires_in_path(path).each { |f| require File.join(root, f) }
        end
      end
    end

    def logger
      @logger ||= Logger.new(STDOUT)
    end

    def environment
      @environment ||= ENV['SHANTY_ENV'] || 'local'
    end

    def build_number
      @build_number ||= (ENV['SHANTY_BUILD_NUMBER'] || 1).to_i
    end

    def root
      @root ||= find_root
    end

    def config
      return @config unless @config.nil?
      return @config = {} unless File.exist?(config_path)
      config = YAML.load_file(config_path) || {}
      @config = config[environment] || {}
    end

    private

    def requires_in_path(path)
      if File.directory?(path)
        Dir[File.join(path, '**', '*.rb')]
      elsif File.exist?(path)
        [path]
      else
        Dir[path]
      end
    end

    def config_path
      "#{root}/#{CONFIG_FILE}"
    end

    def find_root
      if root_dir.nil?
        fail "Could not find a #{CONFIG_FILE} file in this or any parent directories. \
        Please run `shanty init` in the directory you want to be the root of your project structure."
      end

      root_dir
    end

    def root_dir
      Pathname.new(Dir.pwd).ascend do |d|
        return d.to_s if d.join(CONFIG_FILE).exist?
      end
    end
  end
end
