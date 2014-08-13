require 'shanty/discoverers/shantyfile'

# All classes referenced belong to the shanty project
module Shanty
  RSpec.describe Shanty::ShantyfileDiscoverer do
    let(:project_templates) do
      Dir.chdir('examples') do
        ShantyfileDiscoverer.new.discover
      end
    end
    let(:project1) { 'test-static-project' }
    let(:project2) { 'test-static-project-2' }
    let(:project3) { 'test-static-project-3' }
    let(:project_names) { [project1, project2, project3] }
    let(:project_parents) { [[], [project1], [project2]] }
    let(:project_parents) do
      [
        File.join(Dir.pwd, 'examples', project1),
        File.join(Dir.pwd, 'examples', project2),
        File.join(Dir.pwd, 'examples', project2, project3)
      ]
    end

    describe '#discovered' do
      it 'finds example projects' do
        expect(project_templates.size).to be == 3
      end

      it 'finds project templates named' do
        project_names = project_templates.map { |project| project.name }
        expect(project_names).to contain_exactly(*project_names)
      end

      it 'finds project templates with parents' do
        project_parents = project_templates.map { |project| project.parents }
        expect(project_parents).to contain_exactly(*project_parents)
      end

      it 'finds project templates with paths' do
        project_paths = project_templates.map { |project| project.path }
        expect(project_paths).to contain_exactly(*project_paths)
      end
    end
  end
end
