require 'shanty/discoverer'
require 'shanty/projects/static'

module Shanty
  # Public: Discoverer for Shantyfiles
  # will create a a project for every Shantyfile it finds in
  # a directory
  class ShantyfileDiscoverer < Discoverer
    def discover
      Dir['**/Shantyfile'].map do |path|
        create_project(File.absolute_path(File.dirname(path)))
      end
    end
  end
end
