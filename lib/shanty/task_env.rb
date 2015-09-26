require 'shanty/plugin'
require 'shanty/project_sorter'

module Shanty
  #
  module TaskEnv
    # Idiom to allow singletons that can be mixed in: http://ozmm.org/posts/singin_singletons.html
    extend self

    def clear!
      @graph = nil
    end

    def graph
      @graph ||= ProjectSorter.new(Plugin.all_projects).sort.tap do |graph|
        Plugin.all_with_graph(graph)
      end
    end
  end
end
