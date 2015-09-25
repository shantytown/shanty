require 'shanty/plugin'

module Shanty
  # Public: Plugin for finding all directories marked with a Shantyfile.
  class ShantyfilePlugin < Plugin
    projects :shantyfile_projects

    def shantyfile_projects
      project_tree.glob('**/Shantyfile').map do |shantyfile_path|
        Project.new(File.absolute_path(File.dirname(shantyfile_path))).tap do |project|
          project.instance_eval(File.read(shantyfile_path), shantyfile_path)
        end
      end
    end
  end
end
