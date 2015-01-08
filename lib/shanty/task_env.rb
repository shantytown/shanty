require 'deep_merge'
require 'yaml'

module Shanty
  #
  class TaskEnv
    CONFIG_FILE = '.shanty.yml'
    DEFAULT_CONFIG = {}

    def load!
      (config['require'] || {}).each do |requirement|
        requirement = "#{requirement}/**/*.rb" unless requirement.include?('.rb')
        Dir[requirement].each { |f| require f }
      end
    end

    def graph
      @graph ||= construct_project_graph
    end

    private

    def environment
      @environment = ENV['SHANTY_ENV'] || 'local'
    end

    def root
      @root ||= find_root
    end

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
        Discoverer.new.discover_all
      end

      projects = project_templates.map do |project_template|
        project_template.type.new(project_template)
      end

      graph = Graph.new(projects)

      Mutator.new.apply_mutations(graph)
    end
  end
end
