require 'shanty/mixins/attr_combined_accessor'
require 'shanty/projects/static'

module Shanty
  # Public: Allows creation of a project using a discoverer
  class ProjectTemplate
    extend Mixins::AttrCombinedAccessor

    attr_combined_accessor :name, :type, :plugins, :parents, :options, :after_create
    attr_reader :path

    def initialize(path, args = {})
      fail 'Path to project must be a directory.' unless File.directory?(path)

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

      return unless File.exist?(shantyfile_path)

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
  end
end
