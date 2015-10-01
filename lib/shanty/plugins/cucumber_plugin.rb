require 'shanty/plugin'
require 'shanty/project'

module Shanty
  module Plugins
    # Public: Cucumber plugin for testing ruby projects.
    class CucumberPlugin < Plugin
      # By default, we'll detect Cucumber in a project if has a dependency on it in a Gemfile or *.gemspec file. If you
      # don't use these files, you'll need to import the plugin manually using a Shantyfile as we can't tell if RSpec is
      # being used from the presence of a spec directory alone (this can be many other testing frameworks!)
      provides_projects :cucumber_projects
      subscribe :test, :cucumber

      def self.cucumber_projects(env)
        env.file_tree.glob('**/{*.gemspec,Gemfile}').each_with_object([]) do |dependency_file, acc|
          next unless File.read(dependency_file) =~ /['"]cucumber['"]/
          acc << find_or_create_project(File.absolute_path(File.dirname(dependency_file)), env)
        end
      end

      def cucumber
        system 'cucumber'
      end
    end
  end
end
