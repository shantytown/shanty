require 'shanty/mutator'

module Shanty
  # Git VCS mutator
  class Git < Mutator
    def mutate(graph)
      diff_files = `git diff --name-only #{@from_commit} #{@to_commit}`.split("\n")
      diff_files.each do |path|
        project = graph.owner_of_file(path)
        project.changed = true
      end
    end

    def from_commit
      'HEAD^^'
    end

    def to_commit
      'HEAD'
    end
  end
end
