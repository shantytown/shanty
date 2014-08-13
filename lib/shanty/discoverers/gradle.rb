require 'shanty/discoverer'
require 'shanty/projects/static'

module Shanty
  # Gradle discoverer
  class ShantyfileDiscoverer < Discoverer
    def discover
      Dir['**/build.gradle'].map do |path|
        create_project(
          File.dirname(path),
          type: GradleProject,
          options: { foo: 'bar' },
          plugins: [GradlePlugin], parents: ['']
        )
      end
    end
  end
end
