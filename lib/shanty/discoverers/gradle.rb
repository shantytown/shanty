require 'shanty/discoverer'
require 'shanty/projects/static'

module Shanty
  class ShantyfileDiscoverer < Discoverer
    def discover
      Dir['**/build.gradle'].map do |path|
        create_project(File.dirname(path), GradleProject, foo: 'bar')
      end
    end
  end
end
