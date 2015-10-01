require 'spec_helper'
require 'tmpdir'
require 'shanty/graph_factory'

RSpec.describe(Shanty::GraphFactory) do
  include_context('workspace')
  subject { described_class.new(env) }
  let(:env) { double('env') }
  let(:plugins) do
    [
      double('plugin one'),
      double('plugin two'),
      double('plugin three')
    ]
  end
  let(:projects) do
    [
      double('project one'),
      double('project two'),
      double('project three')
    ]
  end

  before do
    allow(env).to receive(:plugins).and_return(plugins)
    allow(plugins.first).to receive(:projects).and_return([projects.first])
    allow(plugins[1]).to receive(:projects).and_return([projects[1]])
    allow(plugins[2]).to receive(:projects).and_return([projects[2]])

    allow(projects.first).to receive(:path).and_return(project_paths.first)
    allow(projects[1]).to receive(:path).and_return(project_paths[1])
    allow(projects[2]).to receive(:path).and_return(project_paths[2])

    allow(projects.first).to receive(:parents).and_return([])
    allow(projects[1]).to receive(:parents).and_return([projects.first])
    allow(projects[2]).to receive(:parents).and_return([projects[1]])
  end

  describe('#graph') do
    it("returns a graph with the projects sorted using Tarjan's strongly connected components algorithm") do
      graph = subject.graph

      expect(graph.first).to eql(projects.first)
      expect(graph[1]).to eql(projects[1])
      expect(graph[2]).to eql(projects[2])
    end
  end
end
