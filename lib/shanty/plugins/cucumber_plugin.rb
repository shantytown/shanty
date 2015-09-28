require 'shanty/plugin'

module Shanty
  # Public: Cucumber plugin for testing ruby projects.
  class CucumberPlugin < Plugin
    subscribe :test, :cucumber
    # By default, we'll detect Cucumber in a project if has a dependency on it in a Gemfile or *.gemspec file. If you
    # don't use these files, you'll need to import the plugin manually using a Shantyfile as we can't tell if RSpec is
    # being used from the presence of a spec directory alone (this can be many other testing frameworks!)
    projects :cucumber_projects

    def cucumber_projects
      project_tree.glob('**/{*.gemspec,Gemfile}').each_with_object([]) do |dependency_file, acc|
        next unless File.read(dependency_file) =~ /['"]cucumber['"]/
        acc << Project.new(File.absolute_path(File.dirname(dependency_file)))
      end
    end

    def cucumber(_)
      system 'cucumber'
    end
  end
end
