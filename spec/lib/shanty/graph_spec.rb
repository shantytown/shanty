require 'shanty/graph'
require 'shanty/project'

RSpec.describe Shanty::Graph do
  before do
    @projects = [
      Shanty::Project.new,
      Shanty::Project.new
    ]

    @graph = Shanty::Graph.new(@projects)
  end

  describe '#changed' do
    it 'should return only projects where #changed? is true' do
      @projects.first.changed = false

      returned = @graph.changed

      expect(returned).to contain_exactly(@projects.last)
    end
  end
end
