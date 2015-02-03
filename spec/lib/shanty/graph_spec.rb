require 'spec_helper'
require 'tmpdir'
require 'shanty/graph'
require 'shanty/projects/static_project'

# Allows all classes to be refereneced without the module name
module Shanty
  RSpec.describe(Graph) do
    include_context('graph')

    describe('enumerable methods') do
      it('returns projects linked together with parent relationships') do
        expect(graph[0].parents.map(&:path)).to eql([])
        expect(graph[1].parents.map(&:path)).to eql([project_paths[:one]])
        expect(graph[2].parents.map(&:path)).to eql([project_paths[:two]])
      end

      it('returns projects linked together with child relationships') do
        expect(graph[0].children.map(&:path)).to eql([project_paths[:two]])
        expect(graph[1].children.map(&:path)).to eql([project_paths[:three]])
        expect(graph[2].children.map(&:path)).to eql([])
      end

      it("returns projects sorted using Tarjan's strongly connected components algorithm") do
        expect(graph[0].path).to equal(project_paths[:one])
        expect(graph[1].path).to equal(project_paths[:two])
        expect(graph[2].path).to equal(project_paths[:three])
      end
    end

    describe('#changed') do
      it('returns only projects where #changed? is true') do
        graph.first.changed = true

        expect(graph.changed).to contain_exactly(graph.first)
      end
    end

    describe('#by_name') do
      it('returns nil when finding a name that does not exist') do
        expect(graph.by_name('foobarlux')).to be_nil
      end

      it('returns the correct project when finding a name that does exist') do
        expect(graph.by_name(graph.first.name)).to equal(graph.first)
      end
    end

    describe('#all_of_type') do
      it('returns an empty array when no types are given') do
        expect(graph.all_of_type).to be_empty
      end

      it('returns an empty array when no projects match the types given') do
        expect(graph.all_of_type(Project)).to be_empty
      end

      it('returns the correct projects when matching types are given') do
        expect(graph.all_of_type(StaticProject)).to match_array(graph)
      end
    end

    describe('#changed_of_type') do
      before do
        graph.first.changed = true
      end

      it('returns an empty array when no types are given') do
        expect(graph.changed_of_type).to be_empty
      end

      it('returns an empty array when no projects match the types given') do
        expect(graph.changed_of_type(Project)).to be_empty
      end

      it('returns the correct projects when matching types are given') do
        expect(graph.changed_of_type(StaticProject)).to contain_exactly(graph.first)
      end
    end

    describe('#owner_of_file') do
      it('returns nil if the given folder is outside of any project') do
        expect(graph.owner_of_file('/tmp')).to be_nil
      end

      it('returns the correct project that owns a given folder') do
        expect(graph.owner_of_file(project_paths[:three]).path).to equal(project_paths[:three])
      end
    end

    describe('#projects_within_path') do
      let(:projects_within_path) { graph.projects_within_path(project_paths[:two]) }

      it('returns all the projects at or below the given path') do
        expect(projects_within_path.map(&:path)).to contain_exactly(project_paths[:two], project_paths[:three])
      end
    end
  end
end
