require 'json'

class Shanty::Graph::Discovery::ProjectJson < Shanty::Graph::Discovery::Base
  def discover(root_dir, current_branch, build_number)
    Dir["#{root_dir}/**/#{Shanty.project_file}"].map do |project_file_path|
      rel_path = File.dirname(project_file_path)[(root_dir.length + 1)..-1]

      json = File.open(project_file_path) { |file| JSON.load(file)}
      name = json.delete('name')
      type = json.delete('type')

      raise "Bad type for project #{name}." if type.nil?

      Shanty::Graph::Project::Base.create(type, name, rel_path, current_branch, root_dir, build_number, json)
    end
  end
end
