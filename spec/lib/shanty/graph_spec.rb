require 'tmpdir'

require 'shanty/graph'
require 'shanty/projects/static'
require 'shanty/project_template'

module Shanty
  RSpec.describe Graph do
    before do
      @project_paths = [
        File.join('examples', 'test-static-project'),
        File.join('examples', 'test-static-project-2'),
        File.join('examples', 'test-static-project-2', 'test-static-project-3')
      ]

      @project_templates = @project_paths.map { |project_path| ProjectTemplate.new(project_path) }
      @projects = @project_templates.map { |project_template| StaticProject.new(project_template) }

      @graph = Graph.new(@projects)
    end

    describe '#changed' do
      it 'should return only projects where #changed? is true' do
        @projects.first.changed = true

        expect(@graph.changed).to contain_exactly(@projects.first)
      end
    end

    describe '#by_name' do
      it 'should return nil when finding a name that does not exist' do
        expect(@graph.by_name('foobarlux')).to be_nil
      end

      it 'should return the correct project when finding a name that does exist' do
        expect(@graph.by_name(@projects.first.name)).to equal(@projects.first)
      end
    end

    describe '#all_of_type' do
      it 'should return an empty array when no types are given' do
        expect(@graph.all_of_type).to be_empty
      end

      it 'should return an empty array when no projects match the types given' do
        expect(@graph.all_of_type(Project)).to be_empty
      end

      it 'should return the correct projects when matching types are given' do
        expect(@graph.all_of_type(StaticProject)).to match_array(@projects)
      end
    end

    describe '#changed_of_type' do
      before do
        @projects.first.changed = true
      end

      it 'should return an empty array when no types are given' do
        expect(@graph.changed_of_type).to be_empty
      end

      it 'should return an empty array when no projects match the types given' do
        expect(@graph.changed_of_type(Project)).to be_empty
      end

      it 'should return the correct projects when matching types are given' do
        expect(@graph.changed_of_type(StaticProject)).to contain_exactly(@projects.first)
      end
    end

    describe '#owner_of_file' do
      it 'should return nil if the given folder is outside of any project' do
        expect(@graph.owner_of_file('/tmp')).to be_nil
      end

      it 'should return the correct project that owns a given folder' do
        expect(@graph.owner_of_file(@project_paths.first)).to equal(@projects.first)
      end
    end
  end
end
