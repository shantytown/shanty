require 'shanty/mixins/attr_combined_accessor'
require 'shanty/projects/static'

module Shanty
  class ProjectTemplate
    extend Mixins::AttrCombinedAccessor

    attr_combined_accessor :name, :type, :plugins, :options
    attr_reader :is_root, :project_block

    def initialize(path, type = StaticProject)
      raise 'Path to project must be a directory.' unless File.directory?(path)

      @path = path
      @type = type
      @name = File.basename(path)
      @plugins = []
      @options = {}
    end

    def execute_shantyfile
      shantyfile_path = File.join(@path, 'Shantyfile')

      return unless File.exists?(shantyfile_path)

      load shantyfile_path
    end

    def plugin(plugin)
      @plugins << plugin
    end

    def option(key, value)
      @options[key] = value
    end

    def project(&block)
      @project_block = block
    end
  end
end
