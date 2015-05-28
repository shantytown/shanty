require 'delegate'

require 'shanty/plugin'
require 'shanty/project'

module Shanty
  #
  class TaskEnv < SimpleDelegator
    alias_method :env, :__getobj__

    def graph
      @graph ||= Graph.new(env, projects).tap do |graph|
        Plugin.with_graph(env, graph)
      end
    end

    private

    def projects
      Plugin.discover_all_projects(env).map do |path, plugins|
        Project.new(env, path).tap do |project|
          plugins.each { |plugin| project.plugin(plugin) }
          project.execute_shantyfile!
        end
      end
    end
  end
end
