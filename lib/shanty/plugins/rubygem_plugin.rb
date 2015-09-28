require 'shanty/plugin'
require 'shanty/artifact'

module Shanty
  # Public: Rubygem plugin for buildin gems.
  class RubygemPlugin < Plugin
    ARTIFACT_EXTENSION = 'gem'

    tags :rubygem
    projects '**/*.gemspec'
    subscribe :build, :build_gem

    def build_gem(project)
      gemspec_files(project).each do |file|
        system "gem build #{file}"
      end
    end

    def artifacts(project)
      gemspec_files(project).flat_map do |file|
        gemspec = Gem::Specification.load(file)
        Artifact.new(
          ARTIFACT_EXTENSION,
          'rubygem',
          URI("file://#{project.path}/#{gemspec.name}-#{gemspec.version}.#{ARTIFACT_EXTENSION}")
        )
      end
    end

    private

    def gemspec_files(project)
      @gemspec_files ||= project_tree.glob(File.join(project.path, '*.gemspec'))
    end
  end
end
