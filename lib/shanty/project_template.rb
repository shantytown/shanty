require 'attr_combined_accessor'

module Shanty
  # Public: Allows creation of a project using a discoverer
  class ProjectTemplate
    attr_combined_accessor :name, :priority, :plugins, :parents, :options
    attr_reader :env, :path

    def initialize(env, path)
      fail 'Path to project must be a directory.' unless File.directory?(path)

      @env = env
      @path = path

      @name = File.basename(path)
      @priority = 0
      @plugins = []
      @parents = []
      @options = {}
    end

    def setup!
      execute_shantyfile
      self
    end

    def plugin(plugin)
      @plugins << plugin
    end

    def parent(parent)
      # Will make the parent path relative to the root if (and only if) it is relative.
      @parents << File.expand_path(parent, @env.root)
    end

    def option(key, value)
      @options[key] = value
    end

    def after_create(&block)
      if block.nil?
        @after_create
      else
        @after_create = block
      end
    end

    private

    def execute_shantyfile
      shantyfile_path = File.join(@path, 'Shantyfile')
      return unless File.exist?(shantyfile_path)
      instance_eval(File.read(shantyfile_path), shantyfile_path)
    end
  end
end
