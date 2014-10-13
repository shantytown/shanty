require 'shanty/task'
require 'shanty/util'

module Shanty
  # Public: A set of basic tasks that can be applied to all projects and that
  # ship with the core of Shanty.
  class BasicTasks < Shanty::Task
    desc 'Lists all projects. If --changed is specified, lists only changed projects.'
    option :changed, type: :boolean
    option :types, type: :array
    def projects(options, graph)
      graph.all.each do |project|
        next if options.changed? && project.changed?
        puts project
      end
    end

    desc 'Executes the build of all projects.'
    option :all, type: :boolean, desc: 'Whether to build all projects, or just changed ones. Defaults to false.'
    option :watch, type: :boolean
    def build(options, graph)
      graph.all.each do |project|
        next unless options.all? || project.changed?
        project.publish(:build)
      end
    end

    desc 'Executes the tests of all projects.'
    option :all, type: :boolean, desc: 'Whether to build all projects, or just changed ones. Defaults to false.'
    option :watch, type: :boolean
    def test(options, graph)
      graph.all.each do |project|
        next unless options.all? || project.changed?
        project.publish(:test)
      end
    end
  end
end
