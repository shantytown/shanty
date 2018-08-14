module Shanty
  # Public: Encapsulates the directory tree of a Shanty project. This provides a
  # way to glob the project tree in a performant way without globing through
  # files that are ignored by Git, SVN some other VCS.
  #
  # FIXME: The ignores are not implemented yet, this work has been recorded in
  # issue #9 (https://github.com/shantytown/shanty/issues/9).
  class FileTree
    # Allow double globbing, and matching hidden files.
    GLOB_FLAGS = File::FNM_EXTGLOB | File::FNM_DOTMATCH
    # FIXME: Basic ignores until the .gitignore file can be loaded instead.
    IGNORE_REGEX = %r{/(vendor|.git)/}

    # Public: Initialise the ProjectTree instance.
    #
    # root - The absolute path to the root of the project within which any file
    #        operations should be performed.
    def initialize(root)
      @root = root
    end

    # Public: Get the full list of files in the project tree, with any files
    # ignored by Git, SVN or some other VCS removed from the list.
    #
    # Returns an Array of Strings where the strings are paths within the
    # project.
    def files
      @files ||= Dir.glob(File.join(@root, '**/*'), GLOB_FLAGS).select do |path|
        File.file?(path) && path !~ IGNORE_REGEX
      end
    end

    # Public: Get the changed list of files in the project tree, with any files
    # ignored by Git, SVN or some other VCS removed from the list.
    #
    # Returns an Array of Strings where the strings are paths within the
    # project that are changed.
    def changed_files
      # FIXME: Implement properly once changed detection is available.
      files
    end

    # Public: Get a list of the files in the project tree that match any of the
    # given globs, with any files ignored by Git, SVN or some other VCS
    # removed from the list.
    #
    # Returns an Array of Strings where the strings are paths within the
    # project that matched.
    def glob(*globs)
      files.find_all do |path|
        globs.any? { |pattern| File.fnmatch(pattern, path, File::FNM_EXTGLOB) }
      end
    end

    # Public: Get a list of the changed files in the project tree that match any
    # of the given globs, with any files ignored by Git, SVN or some other VCS
    # removed from the list.
    #
    # Returns an Array of Strings where the strings are paths within the
    # project that are changed and matched.
    def glob_changed(*globs)
      # FIXME: Implement properly once changed detection is available.
      glob(*globs)
    end

    # Public: Whether the given path is in the project tree.
    #
    # path - An absolute path to check for the presence of in the project tree.
    #
    # Returns a boolean, true if the project does exist in the project tree.
    def exists?(path)
      files.include?(path)
    end

    # Public: Whether the given path is present and changed in the project tree.
    #
    # path - An absolute path to check for the presence and changed status of in
    #        the project tree.
    #
    # Returns a boolean, true if the project does exist in the project tree and
    # is changed.
    def changed?(path)
      # FIXME: Implement properly once changed detection is available.
      exists?(path)
    end
  end
end
