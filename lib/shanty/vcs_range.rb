require 'shanty/util'

module Shanty
  # Public: Enables discovery of rangeerent types of CI provider
  # utilises inherited class method to find all implementing
  # classes
  class VCSRange
    class << self
      attr_reader :vcs_range
    end

    def self.inherited(vcs_range)
      Util.logger.debug("Detected VCS range #{vcs_range}")
      @vcs_range = vcs_range
    end

    def from_commit
      vcs_range.from_commit
    end

    def to_commit
      vcs_range.to_commit
    end

    private

    def vcs_range
      @vcs_range ||= self.class.vcs_range.new
    end
  end
end
