require 'tmpdir'

require 'shanty/graph'
require 'shanty/projects/static'
require 'shanty/project_template'

# Allows all classes to be refereneced without the module name
module Shanty
  RSpec.describe Graph do
    let(:project_paths) do
      [
        File.join('examples', 'test-static-project-2', 'test-static-project-3'),
        File.join('examples', 'test-static-project-2'),
        File.join('examples', 'test-static-project')
      ]
    end
    let(:project_templates) { project_paths.map { |project_path| ProjectTemplate.new(project_path) } }
    let(:projects) { project_templates.map { |project_template| StaticProject.new(project_template) } }
    let(:graph) { Graph.new(projects) }

    describe '#projects' do
      it 'returns projects linked together with parent relationships' do
        projects = graph.projects

        expect(projects[0].parents).to eql([])
        expect(projects[1].parents).to eql([projects[0]])
        expect(projects[2].parents).to eql([projects[1]])
      end

      it 'returns projects linked together with child relationships' do
        projects = graph.projects

        expect(projects[0].children).to eql([projects[1]])
        expect(projects[1].children).to eql([projects[2]])
        expect(projects[2].children).to eql([])
      end

      it 'returns projects sorted from roots to leaves' do
        graph_projects = graph.projects

        expect(projects[0]).to equal(graph_projects[2])
        expect(projects[1]).to equal(graph_projects[1])
        expect(projects[2]).to equal(graph_projects[0])
      end
    end

    describe '#changed' do
      it 'returns only projects where #changed? is true' do
        projects.first.changed = true

        expect(graph.changed).to contain_exactly(projects.first)
      end
    end

    describe '#by_name' do
      it 'returns nil when finding a name that does not exist' do
        expect(graph.by_name('foobarlux')).to be_nil
      end

      it 'returns the correct project when finding a name that does exist' do
        expect(graph.by_name(projects.first.name)).to equal(projects.first)
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
        expect(graph.all_of_type(StaticProject)).to match_array(projects)
      end
    end

    describe '#changed_of_type' do
      before do
        projects.first.changed = true
      end

      it 'returns an empty array when no types are given' do
        expect(graph.changed_of_type).to be_empty
      end

      it 'returns an empty array when no projects match the types given' do
        expect(graph.changed_of_type(Project)).to be_empty
      end

      it 'returns the correct projects when matching types are given' do
        expect(graph.changed_of_type(StaticProject)).to contain_exactly(projects.first)
      end
    end

    describe '#owner_of_file' do
      it 'returns nil if the given folder is outside of any project' do
        expect(graph.owner_of_file('/tmp')).to be_nil
      end

      it 'returns the correct project that owns a given folder' do
        expect(graph.owner_of_file(project_paths.first)).to equal(projects.first)
      end
    end
  end
end
