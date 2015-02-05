module Shanty
  # Public: Discover shanty tasks
  class TaskSet
    attr_reader :task_env

    def initialize(task_env)
      @task_env = task_env
    end

    # This method is auto-triggered by Ruby whenever a class inherits from
    # Shanty::TaskSet. This means we can build up a list of all the tasks
    # without requiring them to register with us - neat!
    def self.inherited(task_set)
      task_sets << task_set
    end

    def self.task_sets
      @task_sets ||= []
    end

    def self.tasks
      @tasks ||= {}
    end

    def self.partial_task
      @partial_task ||= {
        klass: self,
        options: {},
        params: {}
      }
    end

    def self.desc(syntax, desc)
      partial_task[:syntax] = syntax
      partial_task[:desc] = desc
    end

    def self.param(name, options = {})
      partial_task[:params][name] = options
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
