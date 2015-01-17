module Shanty
  # Public: Discover shanty tasks
  class TaskSet
    class << self
      attr_reader :task_sets, :tasks, :partial_task
    end

    # This method is auto-triggered by Ruby whenever a class inherits from
    # Shanty::TaskSet. This means we can build up a list of all the tasks
    # without requiring them to register with us - neat!
    def self.inherited(task_set)
      @task_sets ||= []
      @task_sets << task_set
    end

    def self.desc(syntax, desc)
      partial_task[:syntax] = syntax
      partial_task[:desc] = desc
    end

    def self.param(name, options = {})
      partial_task[:params][name] = options
    end

    def self.option(name, options = {})
      partial_task[:options][name] = options
    end

    def self.method_added(name)
      @tasks ||= {}
      @tasks[name] = partial_task.merge(klass: self)

      # Now reset the task definition.
      @partial_task = {}
    end

    def self.partial_task
      @partial_task ||= {}
      @partial_task[:params] ||= {}
      @partial_task[:options] ||= {}

      @partial_task
    end
  end
end
