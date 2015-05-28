require 'find'
require 'fileutils'
require 'set'
require 'zlib'

#
class DirectoryIndex
  DEFAULT_EXCLUDES = '{.git,.svn}'
  UNIT_SEPARATOR = "\u001F"

  def initialize(root, index_path)
    fail('Cannot create a directory index, path is not a directory.') unless File.directory?(root)

    @root = root
    @index_path = index_path
  end

  def index
    Set.new(saved_index.keys + new_index.keys).to_a
  end

  def save_index!
    FileUtils.mkdir_p(File.dirname(@index_path))
    Zlib::GzipWriter.open(File.open(@index_path, 'w+')) do |f|
      new_index.each do |path, attrs|
        f.puts(attrs.unshift(path).join(UNIT_SEPARATOR))
      end
    end
  end

  def all_changed
    binding.pry
    index.find_all { |path| changed?(path) }
  end

  def changed?(path)
    new?(path) || deleted?(path) || modified?(path)
  end

  def new?(path)
    cached = saved_index[path]
    current = new_index[path]
    cached.nil? && !current.nil?
  end

  def deleted?(path)
    cached = saved_index[path]
    current = new_index[path]
    !cached.nil? && current.nil?
  end

  def modified?(path)
    cached = saved_index[path]
    current = new_index[path]
    !cached.nil? && !current.nil? && current != cached
  end

  private

  def saved_index
    return @saved_index unless @saved_index.nil?
    return (@saved_index = {}) unless File.exist?(@index_path)

    @saved_index = Zlib::GzipReader.open(@index_path).each_line.each_with_object({}) do |line, acc|
      path, *attrs = line.split(UNIT_SEPARATOR)
      acc[path] = attrs.map(&:to_i)
    end
  end

  def new_index
    @new_index ||= Find.find(@root).each_with_object({}) do |path, acc|
      # If any of our ignore rules match, exclude this and any subfiles from the index.
      next Find.prune if ignore_globs.any? { |glob| File.fnmatch?(glob, path, File::FNM_EXTGLOB) }
      next unless File.exist?(path)
      s = File.stat(path)
      next if s.directory?

      acc[path] = [s.mtime.to_i, s.size]
    end
  end

  def ignore_globs
    excludes = [DEFAULT_EXCLUDES]
    excludes.concat(File.readlines(ignore_file).map(&:strip)) if File.exist?(ignore_file)

    excludes.map do |rule|
      corrected_rule = [rule]
      corrected_rule.unshift('*') unless rule.start_with?('*')
      corrected_rule.push('*') unless rule.end_with?('*')
      corrected_rule.join('')
    end
  end

  def ignore_file
    File.join(@root, '.gitignore')
  end
end
