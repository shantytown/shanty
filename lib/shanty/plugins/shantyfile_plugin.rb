require 'shanty/plugin'
require 'shanty/project'

module Shanty
  module Plugins
    # Public: Plugin for finding all directories marked with a Shantyfile.
    class ShantyfilePlugin < Plugin
      provides_projects :shantyfile_projects
      description 'Discovers and configures projects with a Shantyfile'

      def self.shantyfile_projects(env)
        env.file_tree.glob('**/Shantyfile').map do |shantyfile_path|
          find_or_create_project(File.absolute_path(File.dirname(shantyfile_path)), env).tap do |project|
            project.instance_eval(File.read(shantyfile_path), shantyfile_path)
          end
        end
      end
    end
  end
end
