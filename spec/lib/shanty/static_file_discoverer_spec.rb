require 'shanty/discoverers/shantyfile'

# All classes referenced belong to the shanty project
module Shanty
  RSpec.describe Shanty::ShantyfileDiscoverer do
    before do
      @project_templates = Dir.chdir('examples') do
        Discoverer.find_all
      end
      project1 = 'test-static-project'
      project2 = 'test-static-project-2'
      project3 = 'test-static-project-3'
      @project_names = [project1, project2, project3]
      @project_parents = [[], [project1], [project2]]
      @project_paths = [
        File.join(Dir.pwd, 'examples', project1),
        File.join(Dir.pwd, 'examples', project2),
        File.join(Dir.pwd, 'examples', project2, project3)
      ]
    end

    describe '#discovered' do
      it 'should find example projects' do
        expect(@project_templates.size).to be == 3
      end

      it "should find project templates named #{@project_names.inspect}" do
        project_names = @project_templates.map { |project| project.name }
        expect(project_names).to contain_exactly(*@project_names)
      end

      it "should find project templates with parents #{@project_parents.inspect}" do
        project_parents = @project_templates.map { |project| project.parents }
        expect(project_parents).to contain_exactly(*@project_parents)
      end

      it "should find project templates with paths #{@project_paths.inspect}" do
        project_paths = @project_templates.map { |project| project.path }
        expect(project_paths).to contain_exactly(*@project_paths)
      end
    end
  end
end
