require 'shanty/discoverer'

module Shanty
  # Public: Discoverer for Shantyfiles
  #
  # It will create a project for every Shantyfile it finds in
  # a directory
  #
  # Note that this does not execute the Shantyfile. That
  # happens inside the ProjectTemplate as we may have projects
  # discovered by other discoverers that still need
  # customisation.
  class ShantyfileDiscoverer < Discoverer
    def discover
      Dir[File.join(env.root, '**', 'Shantyfile')].map do |path|
        create_project_template(File.absolute_path(File.dirname(path))) do |project_template|
          project_template.priority = -1
        end
      end
    end
  end
end
