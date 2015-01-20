require 'shanty/mixins/attr_combined_accessor'
require 'shanty/projects/static'

module Shanty
  # Public: Allows creation of a project using a discoverer
  class ProjectTemplate
    extend Mixins::AttrCombinedAccessor

    attr_combined_accessor :name, :type, :plugins, :parents, :options
    attr_reader :root, :path

    def initialize(root, path, args = {})
      fail 'Path to project must be a directory.' unless File.directory?(path)

      @root = root
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

      instance_eval(File.read(shantyfile_path), shantyfile_path)
    end

    def plugin(plugin)
      @plugins << plugin
    end

    def parent(parent)
      # Will make the parent path relative to the root if (and only if) it is relative.
      @parents << File.expand_path(parent, @root)
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
  end
end
