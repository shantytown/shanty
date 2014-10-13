module Shanty
  # Public: Discover shanty tasks
  class Task
    class << self
      attr_reader :tasks
      attr_reader :task_definitions, :task_definiton
    end

    # This method is auto-triggred by Ruby whenever a class inherits from
    # Shanty::Task. This means we can build up a list of all the tasks
    # without requiring them to register with us - neat!
    def self.inherited(task)
      @tasks ||= []
      @tasks << task
    end

    def self.desc(desc)
      task_definition[:desc] = desc
    end

    def self.param(name, options = {})
      task_definition[:params][name] = options
    end

    def self.option(name, options = {})
      task_definition[:options][name] = options
    end

    def self.method_added(name)
      @task_definitions ||= {}
      @task_definitions[name] = task_definition.merge(klass: self)

      # Now reset the task definition.
      @task_definition = {}
    end

    def self.task_definition
      @task_definition ||= {}
      @task_definition[:params] ||= {}
      @task_definition[:options] ||= {}

      @task_definition
    end
  end
end
