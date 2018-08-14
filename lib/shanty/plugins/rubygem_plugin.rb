require 'shanty/plugin'
require 'shanty/artifact'

module Shanty
  module Plugins
    # Public: Rubygem plugin for buildin gems.
    class RubygemPlugin < Plugin
      ARTIFACT_EXTENSION = 'gem'.freeze

      provides_projects_containing '**/*.gemspec'
      provides_tags :gem
      subscribe :build, :build_gem
      description 'Builds a Rubygem for projects with a gemspec file'

      def build_gem
        gemspec_files.each do |file|
          system "gem build #{file}"
        end
      end

      def artifacts
        gemspec_files.flat_map do |file|
          gemspec = Gem::Specification.load(file)
          Artifact.new(
            ARTIFACT_EXTENSION,
            'rubygem',
            URI("file://#{project.path}/#{gemspec.name}-#{gemspec.version}.#{ARTIFACT_EXTENSION}")
          )
        end
      end

      private

      def gemspec_files
        @gemspec_files ||= env.file_tree.glob(File.join(project.path, '*.gemspec'))
      end
    end
  end
end
