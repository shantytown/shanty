require 'spec_helper'
require 'tmpdir'
require 'shanty/graph'
require 'shanty/project'

require_fixture 'test_plugin'
require_fixture 'test_unused_plugin'

# Allows all classes to be refereneced without the module name
module Shanty
  RSpec.describe(ProjectLinker) do
    include_context('graph')
    subject { ProjectLinker.new(projects.values) }

    describe('#link') do
      before do
        projects[:two].parents_by_path << project_paths[:one]
        projects[:three].parents_by_path << project_paths[:two]
      end

      let(:missing_parent) { 'foo-bar-does-not-exist' }

      it('throws an exception if any of the projects have a dependency on a project that does not exist') do
        project.parents_by_path << missing_parent

        expect { subject.link }.to raise_error("Cannot find project at path #{missing_parent}, which \
was specified as a dependency for #{project.name}")
      end

      it('returns a graph with the projects linked together in parent relationships') do
        graph = subject.link

        expect(graph[0].parents.map(&:path)).to eql([])
        expect(graph[1].parents.map(&:path)).to eql([project_paths[:one]])
        expect(graph[2].parents.map(&:path)).to eql([project_paths[:two]])
      end

      it('returns a graph with the projects linked together in child relationships') do
        graph = subject.link

        expect(graph[0].children.map(&:path)).to eql([project_paths[:two]])
        expect(graph[1].children.map(&:path)).to eql([project_paths[:three]])
        expect(graph[2].children.map(&:path)).to eql([])
      end

      it("returns a graph with the projects sorted using Tarjan's strongly connected components algorithm") do
        graph = subject.link

        expect(graph[0].path).to eql(project_paths[:one])
        expect(graph[1].path).to eql(project_paths[:two])
        expect(graph[2].path).to eql(project_paths[:three])
      end
    end
  end
end
