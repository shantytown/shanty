require 'shanty/mutator'
require 'shanty/vcs_ranges/local_git'

module Shanty
  # Git VCS mutator
  class Git < Mutator
    def initialize
      @vcs_range = VCSRange.new
    end

    def mutate(graph)
      git_root = `git rev-parse --show-toplevel`.strip
      diff_files = `git diff --name-only #{@vcs_range.from_commit} #{@vcs_range.to_commit}`.split("\n")
      diff_files.each do |path|
        next if path.nil?
        path = File.join(git_root, path)
        project = graph.owner_of_file(path)
        project.changed = true unless project.nil?
      end

      graph
    end
  end
end
