require 'shanty/discoverer'
require 'shanty/projects/static'

module Shanty
  class ShantyfileDiscoverer < Discoverer
    def discover
      Dir['**/Shantyfile'].map do |path|
        create_project(File.absolute_path(File.dirname(path)))
      end
    end
  end
end
