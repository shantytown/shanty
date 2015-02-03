require 'shanty/discoverer'
require 'shanty/projects/rubygem_project'

module Shanty
  # Public: Discoverer for Shantyfiles
  # will create a a project for every Shantyfile it finds in
  # a directory
  class RubygemDiscoverer < Discoverer
    def discover
      Dir[File.join(env.root, '**', '*.gemspec')].map do |path|
        create_project_template(File.absolute_path(File.dirname(path))) do |project_template|
          project_template.type = RubygemProject
        end
      end
    end
  end
end
