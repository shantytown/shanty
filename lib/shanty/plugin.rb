require 'shanty/util'
require 'shanty/project_template'

module Shanty
  # Some basic functionality for every plugin.
  module Plugin
    def add_to_project(project)
      project.singleton_class.include(self)
      @callbacks.each do |callback|
        project.subscribe(*callback)
      end
    end

    def subscribe(*args)
      @callbacks ||= []
      @callbacks.push(args)
    end
  end
end
