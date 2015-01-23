require 'find'
require 'fileutils'
require 'set'
require 'shanty/mutator'

module Shanty
  # Mutates the graph to mark projects which have changed since the last time they were built.
  class ChangedMutator < Mutator
    UNIT_SEPARATOR = "\u001F"

    def mutate
      FileUtils.mkdir(shanty_dir) unless File.directory?(shanty_dir)

      self.cached_index = all_index_files.each_with_object({}) do |path, acc|
        # Check if the file has changed between
        next if unchanged_in_index?(path)
        # Otherwise, it was modified, deleted or added, so update the index if the file still exists.
        acc[path] = current_index[path] if current_index.include?(path)
        mark_project_as_changed(path)
      end
    end

    private

    def shanty_dir
      File.join(env.root, '.shanty')
    end

    def index_file
      File.join(shanty_dir, 'index')
    end

    def all_index_files
      Set.new(cached_index.keys + current_index.keys).to_a
    end

    def cached_index
      return @cached_index unless @cached_index.nil?
      return (@cached_index = {}) unless File.exist?(index_file)

      @cached_index = File.open(index_file).each_line.each_with_object({}) do |line, acc|
        path, *attrs = line.split(UNIT_SEPARATOR)
        acc[path] = attrs
      end
    end

    def cached_index=(new_index)
      File.open(index_file, 'w+') do |f|
        new_index.each do |path, attrs|
          f.puts(attrs.unshift(path).join(UNIT_SEPARATOR))
        end
      end
    end

    def unchanged_in_index?(path)
      cached = cached_index[path]
      current = current_index[path]
      !cached.nil? && !current.nil? && current == cached
    end

    def current_index
      @current_index ||= Find.find(env.root).each_with_object({}) do |path, acc|
        # FIXME: Pass in list of excludes and match as follows:
        # next Find.prune if path =~ /(build|.git|.gradle)/
        next unless File.exist?(path)
        s = File.stat(path)
        next if s.directory?

        acc[path] = [s.mtime.to_i, s.size]
      end
    end

    def mark_project_as_changed(path)
      project = graph.owner_of_file(File.join(env.root, path))
      project.changed = true unless project.nil?
    end
  end
end
