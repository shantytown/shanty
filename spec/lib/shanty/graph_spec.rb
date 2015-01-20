require 'spec_helper'
require 'tmpdir'

require 'shanty/graph'
require 'shanty/projects/static'
require 'shanty/project_template'

# Allows all classes to be refereneced without the module name
module Shanty
  RSpec.describe Graph do
    let(:root) { File.expand_path(File.join(__dir__, '..', '..', '..')) }
    let(:project_paths) do
      [
        File.join(root, 'examples', 'test-static-project-2', 'test-static-project-3'),
        File.join(root, 'examples', 'test-static-project-2'),
        File.join(root, 'examples', 'test-static-project')
      ]
    end
    let(:project_templates) { project_paths.map { |project_path| ProjectTemplate.new(root, project_path) } }
    let(:graph) { Graph.new(project_templates) }

    describe 'enumerable methods' do
      it 'returns projects linked together with parent relationships' do
        expect(graph[0].parents.map(&:path)).to eql([])
        expect(graph[1].parents.map(&:path)).to eql([project_paths[2]])
        expect(graph[2].parents.map(&:path)).to eql([project_paths[1]])
      end

      it 'returns projects linked together with child relationships' do
        expect(graph[0].children.map(&:path)).to eql([project_paths[1]])
        expect(graph[1].children.map(&:path)).to eql([project_paths[0]])
        expect(graph[2].children.map(&:path)).to eql([])
      end

      it "returns projects sorted using Tarjan's strongly connected components algorithm" do
        expect(graph[0].path).to equal(project_paths[2])
        expect(graph[1].path).to equal(project_paths[1])
        expect(graph[2].path).to equal(project_paths[0])
      end
    end

    describe '#changed' do
      it 'returns only projects where #changed? is true' do
        graph.first.changed = true

        expect(graph.changed).to contain_exactly(graph.first)
      end
    end

    describe '#by_name' do
      it 'returns nil when finding a name that does not exist' do
        expect(graph.by_name('foobarlux')).to be_nil
      end

      it 'returns the correct project when finding a name that does exist' do
        expect(graph.by_name(graph.first.name)).to equal(graph.first)
      end
    end

    describe '#all_of_type' do
      it 'returns an empty array when no types are given' do
        expect(graph.all_of_type).to be_empty
      end

      it 'returns an empty array when no projects match the types given' do
        expect(graph.all_of_type(Project)).to be_empty
      end

      it 'returns the correct projects when matching types are given' do
        expect(graph.all_of_type(StaticProject)).to match_array(graph)
      end
    end

    describe '#changed_of_type' do
      before do
        graph.first.changed = true
      end

      it 'returns an empty array when no types are given' do
        expect(graph.changed_of_type).to be_empty
      end

      it 'returns an empty array when no projects match the types given' do
        expect(graph.changed_of_type(Project)).to be_empty
      end

      it 'returns the correct projects when matching types are given' do
        expect(graph.changed_of_type(StaticProject)).to contain_exactly(graph.first)
      end
    end

    describe '#owner_of_file' do
      it 'returns nil if the given folder is outside of any project' do
        expect(graph.owner_of_file('/tmp')).to be_nil
      end

      it 'returns the correct project that owns a given folder' do
        expect(graph.owner_of_file(project_paths.first).path).to equal(project_paths.first)
      end
    end
  end
end
