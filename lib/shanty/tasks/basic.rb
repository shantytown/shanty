require 'shanty/task'
require 'shanty/util'

module Shanty
  # Public: A set of basic tasks that can be applied to all projects and that
  # ship with the core of Shanty.
  class BasicTasks < Shanty::Task
    desc 'Lists all projects. If --changed is specified, lists only changed projects.'
    option :changed,
           type: :boolean,
           desc: 'Whether to list only changed projects. Defaults to false.'
    option :types,
           type: :array,
           desc: 'An optional list of project types to filter by. By default, all types are shown.'
    def projects(options, graph)
      graph.projects.each do |project|
        next if options.changed? && !project.changed?
        puts project
      end
    end

    desc 'Executes the build of all projects.'
    option :changed,
           type: :boolean,
           desc: 'Whether to build only changed projects. Defaults to false.'
    option :watch,
           type: :boolean,
           desc: 'If true, the command will execute the build whenever a change is detected on disk, quitting only on
             interruption.'
    option :types,
           type: :array,
           desc: 'An optional list of project types to filter by. By default, all types are built.'
    def build(options, graph)
      graph.projects.each do |project|
        next if options.changed? && !project.changed?
        project.publish(:build)
      end
    end

    desc 'Executes the tests of all projects.'
    option :changed,
           type: :boolean,
           desc: 'Whether to test only changed projects. Defaults to false.'
    option :watch,
           type: :boolean,
           desc: 'If true, the command will execute the tests whenever a change is detected on disk, quitting only on
             interruption.'
    option :types,
           type: :array,
           desc: 'An optional list of project types to filter by. By default, all types are tested.'
    def test(options, graph)
      graph.projects.each do |project|
        next if options.changed? && !project.changed?
        success = project.publish(:test)
        fail "The tests failed for the following project: #{project}" unless success
      end
    end
  end
end
