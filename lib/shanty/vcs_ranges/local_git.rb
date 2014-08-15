require 'shanty/vcs_range'

module Shanty
  # Use range of local vs remote changes
  class LocalGit < VCSRange
    def from_commit
      "origin/#{branch}"
    end

    def to_commit
      'HEAD'
    end

    private

    def branch
      `git rev-parse --abbrev-ref HEAD`.strip
    end
  end
end
