require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'shanty/task'

module Shanty
  # Ruby project tasks
  class Ruby < Task
    desc 'test', 'build ruby rake project'
    def test
      # FIXME: Should really have this done automatically before every task with a callback
      graph = Shanty.new.graph
      projects = graph.all_of_type(RubyProject)
      projects.each do |project|
        RuboCop::RakeTask.new("#{project.name}-rubocop")
        RSpec::Core::RakeTask.new("#{project.name}-rspec")
        Rake::Task["#{project.name}-rubocop"].invoke
        Rake::Task["#{project.name}-rspec"].invoke
      end
    end
  end
end
