require 'gitignore_rb'

#
module Shanty
  #
  class ProjectTree
    def initialize(root)
      # FIXME: This does not work if the project doesn't have a .gitignore in the root.
      @gitignore = GitIgnoreRb.new(root)
    end

    def glob(*globs)
      included_files.find_all do |path|
        globs.any? { |pattern| File.fnmatch(pattern, path, File::FNM_EXTGLOB) }
      end
    end

    private

    def included_files
      @included_files ||= @gitignore.included_files
    end
  end
end
