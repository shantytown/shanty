module Shanty
  VERSION = "0.0.1"

  def default_project_file
    'project.json'
  end

  def project_file
    @project_file ||= default_project_file  
  end

  def project_file=(new_project_file)
    @project_file = new_project_file
  end

  module_function :default_project_file, :project_file, :project_file=
end
require 'shanty/cli'
require 'shanty/graph'
require 'shanty/graph/mixins/acts_as_link_graph_node'
require 'shanty/graph/project'
require 'shanty/graph/project/static'
require 'shanty/graph/discovery'
require 'shanty/graph/discovery/project_json'
require 'shanty/graph/project_link_graph'
