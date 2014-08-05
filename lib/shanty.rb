module Shanty
  VERSION - "0.0.1"

  def default_project_file
    'project.json'
  end

  def project_file
    @project_file ||= default_project_file  
  end

  def project_file=(new_project_file)
    @project_file = new_project_file
  end

  module_function :projcet_file, :project_file=
end
