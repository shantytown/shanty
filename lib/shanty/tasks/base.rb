require 'shanty/task'
require 'shanty/util'

module Shanty
  # Cli
  class Base < Task
    desc 'projects', 'Lists projects discovered by shanty'
    def projects
      Util.logger.info(Shanty.new.graph.projects.inspect)
    end

    desc 'changed_projects', 'Lists changed projects discovered by shanty'
    def changed_projects
      Util.logger.info(Shanty.new.graph.changed.inspect)
    end
  end
end
