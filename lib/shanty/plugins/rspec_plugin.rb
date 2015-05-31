require 'shanty/plugin'

module Shanty
  # Public: Rspec plugin for testing ruby projects.
  module RspecPlugin
    extend Plugin

    adds_tags :rspec
    # By default, we'll detect RSpec in a project if has a dependency on it in a Gemfile or *.gemspec file. If you don't
    # use these files, you'll need to import the plugin manually using a Shantyfile as we can't tell if RSpec is being
    # used from the presence of a spec directory alone (this can be many other testing frameworks!)
    wants_projects_matching do
      Dir['**/{*.gemspec,Gemfile}'].each_with_object([]) do |dependency_file, acc|
        next unless File.read(dependency_file) =~ /['"]rspec['"]/
        acc << Project.new(File.absolute_path(File.dirname(dependency_file)))
      end
    end

    subscribe :test, :rspec

    def rspec
      system 'rspec'
    end
  end
end
