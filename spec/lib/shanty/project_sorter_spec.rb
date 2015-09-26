require 'spec_helper'
require 'tmpdir'
require 'shanty/project_sorter'

# Allows all classes to be refereneced without the module name
module Shanty
  RSpec.describe(ProjectSorter) do
    include_context('graph')
    subject { ProjectSorter.new(projects.values) }

    describe('#sort') do
      it("returns a graph with the projects sorted using Tarjan's strongly connected components algorithm") do
        projects[:two].add_parent(projects[:one])
        projects[:three].add_parent(projects[:two])

        graph = subject.sort

        expect(graph[0].path).to eql(project_paths[:one])
        expect(graph[1].path).to eql(project_paths[:two])
        expect(graph[2].path).to eql(project_paths[:three])
      end
    end
  end
end
