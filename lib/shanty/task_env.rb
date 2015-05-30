require 'shanty/plugin'
require 'shanty/project_linker'

module Shanty
  #
  module TaskEnv
    # Idiom to allow singletons that can be mixed in: http://ozmm.org/posts/singin_singletons.html
    extend self

    def clear!
      @graph = nil
    end

    def graph
      return @graph unless @graph.nil?

      projects = Plugin.discover_all_projects.each(&:execute_shantyfile!)
      @graph ||= ProjectLinker.new(projects).link.tap do |graph|
        Plugin.with_graph(graph)
      end
    end
  end
end
