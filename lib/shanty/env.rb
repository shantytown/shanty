require 'i18n'
require 'logger'
require 'pathname'
require 'yaml'
require 'shenanigans/hash/to_ostruct'

require 'shanty/config'
require 'shanty/project_tree'

module Shanty
  #
  module Env
    # Idiom to allow singletons that can be mixed in: http://ozmm.org/posts/singin_singletons.html
    extend self

    CONFIG_FILE = '.shanty.yml'

    # This must be defined first due to being a class var that isn't first
    # first accessed with ||=.
    @@config = nil

    def clear!
      @@logger = nil
      @@environment = nil
      @@build_number = nil
      @@root = nil
      @@config = nil
      @@project_tree = nil
    end

    def require!
      Dir.chdir(root) do
        (config['require'] || []).each do |path|
          requires_in_path(path).each { |f| require File.join(root, f) }
        end
      end
    end

    def logger
      @@logger ||= Logger.new($stdout).tap do |logger|
        logger.formatter = proc do |_, datetime, _, msg|
          "#{datetime}: #{msg}\n"
        end
      end
    end

    def environment
      @@environment ||= ENV['SHANTY_ENV'] || 'local'
    end

    def build_number
      @@build_number ||= (ENV['SHANTY_BUILD_NUMBER'] || 1).to_i
    end

    def root
      @@root ||= find_root
    end

    def project_tree
      @@project_tree ||= ProjectTree.new(root)
    end

    def config
      @@config ||= Config.new(root, environment)
    rescue RuntimeError
      # Create config object without .shanty.yml if the project root cannot be resolved
      @@config ||= Config.new(nil, environment)
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

    def find_root
      fail I18n.t('missing_root', config_file: CONFIG_FILE) if root_dir.nil?
      root_dir
    end

    def root_dir
      Pathname.new(Dir.pwd).ascend do |d|
        return d.to_s if d.join(CONFIG_FILE).exist?
      end
    end
  end
end
