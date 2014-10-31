require 'shanty/task'
require 'shanty/util'

module Shanty
  # Public: A set of basic tasks that can be applied to all projects and that
  # ship with the core of Shanty.
  class BasicTasks < Shanty::Task
    desc 'tasks.projects'
    option :changed, type: :boolean, desc: 'tasks.common.options.changed'
    option :types, type: :array, desc: 'tasks.common.options.types'
    def projects(options, graph)
      graph.projects.each do |project|
        next if options.changed? && !project.changed?
        puts project
      end
    end

    desc 'tasks.build'
    option :changed, type: :boolean, desc: 'tasks.common.options.changed'
    option :watch, type: :boolean, desc: 'tasks.common.options.watch'
    option :types, type: :array, desc: 'tasks.common.options.types'
    def build(options, graph)
      graph.projects.each do |project|
        next if options.changed? && !project.changed?
        project.publish(:build)
      end
    end

    desc 'tasks.test'
    option :changed, type: :boolean, desc: 'tasks.common.options.changed'
    option :watch, type: :boolean, desc: 'tasks.common.options.watch'
    option :types, type: :array, desc: 'tasks.common.options.types'
    def test(options, graph)
      graph.projects.each do |project|
        next if options.changed? && !project.changed?
        success = project.publish(:test)
        fail "The tests failed for the following project: #{project}" unless success
      end
    end
  end
end
