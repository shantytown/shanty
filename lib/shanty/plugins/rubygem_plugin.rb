require 'shanty/plugin'
require 'shanty/artifact'

module Shanty
  # Public: Rubygem plugin for buildin gems.
  class RubygemPlugin < Plugin
    ARTIFACT_EXTENSION = 'gem'

    tags :rubygem
    projects '**/*.gemspec'
    subscribe :build, :build_gem

    def build_gem
      system 'gem build *.gemspec'
    end

    def artifacts(project)
      Dir[File.join(project.path, '*.gemspec')].flat_map do |file|
        gemspec = Gem::Specification.load(file)
        Artifact.new(
          ARTIFACT_EXTENSION,
          'rubygem',
          URI("file://#{project.path}/#{gemspec.name}-#{gemspec.version}.#{ARTIFACT_EXTENSION}")
        )
      end
    end
  end
end
