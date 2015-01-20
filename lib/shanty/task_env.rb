require 'deep_merge'
require 'yaml'

module Shanty
  #
  class TaskEnv
    CONFIG_FILE = '.shanty.yml'
    DEFAULT_CONFIG = {}

    def initialize
      Dir.chdir(root) do
        (config['require'] || {}).each do |requirement|
          requirement = "#{requirement}/**/*.rb" unless requirement.include?('.rb')
          Dir[requirement].each { |f| require(File.join(root, f)) }
        end
      end
    end

    def graph
      @graph ||= construct_project_graph
    end

    def environment
      @environment = ENV['SHANTY_ENV'] || 'local'
    end

    def root
      @root ||= find_root
    end

    private

    def config
      return @config unless @config.nil?

      file_config = YAML.load_file("#{root}/#{CONFIG_FILE}") || {}
      @config = DEFAULT_CONFIG.deep_merge!(file_config[environment])
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
        return d if d.join(CONFIG_FILE).exist?
      end
    end

    def construct_project_graph
      project_templates = Dir.chdir(root) do
        Discoverer.new.discover_all.sort_by(&:priority).reverse.uniq(&:path)
      end

      Graph.new(project_templates).tap do |graph|
        Mutator.new.apply_mutations(graph)
      end
    end
  end
end
