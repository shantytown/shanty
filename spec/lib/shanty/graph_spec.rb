require 'tmpdir'

require 'shanty/graph'
require 'shanty/project'
require 'shanty/project_template'

RSpec.describe Shanty::Graph do
  before do
    @project_templates = [
      Shanty::ProjectTemplate.new(Dir.mktmpdir('shanty')),
      Shanty::ProjectTemplate.new(Dir.mktmpdir('shanty'))
    ]

    @projects = [
      Shanty::Project.new(@project_templates.first),
      Shanty::Project.new(@project_templates.last)
    ]

    @graph = Shanty::Graph.new(@projects)
  end

  describe '#changed' do
    it 'should return only projects where #changed? is true' do
      @projects.first.changed = true

      returned = @graph.changed

      expect(returned).to contain_exactly(@projects.first)
    end
  end
end
