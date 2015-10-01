module Shanty
  # Public: Discover shanty tasks
  class TaskSet
    attr_reader :env, :graph

    def initialize(env, graph)
      @env = env
      @graph = graph
    end

    def self.tasks
      @tasks ||= {}
    end

    def self.partial_task
      @partial_task ||= {
        klass: self,
        options: {}
      }
    end

    def self.desc(syntax, desc)
      partial_task[:syntax] = syntax
      partial_task[:desc] = desc
    end

    def self.option(name, attrs = {})
      partial_task[:options][name] = attrs
    end

    def self.method_added(name)
      tasks[name] = partial_task

      # Now reset the task definition.
      @partial_task = nil
    end
  end
end
