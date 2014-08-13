require 'shanty/mixins/attr_combined_accessor'
require 'shanty/projects/static'

module Shanty
  class ProjectTemplate
    extend Mixins::AttrCombinedAccessor

    attr_combined_accessor :name, :type, :plugins, :parents, :options
    attr_reader :path, :project_block

    def initialize(path, args = {})
      raise 'Path to project must be a directory.' unless File.directory?(path)

      @path = path
      @name = File.basename(path)
      @type = args[:type] || StaticProject
      @plugins = args[:plugins] || []
      @parents = args[:parents] || []
      @options = args[:options] || {}

      execute_shantyfile
    end

    def execute_shantyfile
      shantyfile_path = File.join(@path, 'Shantyfile')

      return unless File.exists?(shantyfile_path)

      eval(File.read(shantyfile_path))
    end

    def plugin(plugin)
      @plugins << plugin
    end

    def parent(parent)
      @parents << parent
    end

    def option(key, value)
      @options[key] = value
    end

    def project(&block)
      @project_block = block
    end
  end
end
