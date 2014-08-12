require 'pathname'
require 'pry'

require 'shanty/discoverers/shantyfile'

module Shanty
  class Shanty
    def initialize
    end

    def root
      @root ||= find_root
    end

    def graph
      @graph ||= construct_project_graph
    end

    private
    def find_root
      root_dir = nil
      Pathname.new(Dir.pwd).ascend do |d|
        if d.join('.shantyroot').exist?
          root_dir = d
          break
        end
      end

      if root_dir.nil?
        raise 'Could not find a .shantyroot file in this or any parent directories. Please run `shanty init` in the directory you want to be the root of your project structure.'
      end

      root_dir
    end

    def construct_project_graph
      project_templates = Dir.chdir(root) do
        Discoverer.find_all
      end

      projects = project_templates.map do |project_template|
        project_template.type.new(project_template)
      end


    end
  end
end
