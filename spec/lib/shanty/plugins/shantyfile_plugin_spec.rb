require 'spec_helper'
require 'shanty/plugins/shantyfile_plugin'

RSpec.describe(Shanty::Plugins::ShantyfilePlugin) do
  include_context('with plugin')

  it('adds the shantyfile tag automatically') do
    expect(described_class).to provide_tags(:shantyfile)
  end

  it('finds projects by calling a method to locate the ones that have a Shantyfile') do
    expect(described_class).to provide_projects(:shantyfile_projects)
  end

  describe('#shantyfile_projects') do
    before do
      allow(file_tree).to receive(:glob).and_return(shantyfiles)

      shantyfiles.each_with_index do |shantyfile, i|
        File.write(shantyfile, "instance_variable_set(:@this_is_a_test, #{i})")
      end
    end

    let(:shantyfiles) do
      [
        File.join(project_paths.first, 'Shantyfile'),
        File.join(project_paths[2], 'Shantyfile')
      ]
    end

    it('finds all projects with a Shantyfile') do
      result = described_class.shantyfile_projects(env).map(&:path)
      expect(result).to contain_exactly(project_paths.first, project_paths[2])
    end

    it('executes the found Shantyfiles within the context of the project') do
      projects = described_class.shantyfile_projects(env)

      expect(projects.first.instance_variable_get(:@this_is_a_test)).to eq(0)
      expect(projects[1].instance_variable_get(:@this_is_a_test)).to eq(1)
    end
  end
end
