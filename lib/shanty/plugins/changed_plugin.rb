require 'shanty/directory_index'
require 'shanty/plugin'

# For each dir
module Shanty
  # Public: Plugin for marking projects as changed since the last time an index was saved.
  module ChangedPlugin
    extend Plugin

    with_graph do |env, graph|
      index(env).all_changed.each do |path|
        project = graph.owner_of_file(path)
        project.plugin(self) unless project.nil?
      end
    end

    def self.index(env)
      @index ||= DirectoryIndex.new(env.root, index_path(env))
    end

    def self.index_path(env)
      File.join(env.root, '.shanty', 'index')
    end
  end
end
