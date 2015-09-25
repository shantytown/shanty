require 'spec_helper'
require 'shanty/plugins/shantyfile_plugin'

# All classes referenced belong to the shanty project
module Shanty
  RSpec.describe(ShantyfilePlugin) do
    include_context('graph')

    it('adds the shantyfile tag') do
      expect(described_class).to add_tags(:shantyfile)
    end

    it('finds projects by calling a method to locate the ones that have a Shantyfile') do
      expect(described_class).to define_projects.with(:shantyfile_projects)
    end

    describe('#shantyfile_projects') do
      it('finds all projects with a Shantyfile') do
        FileUtils.touch(File.join(project_paths[:one], 'Shantyfile'))
        FileUtils.touch(File.join(project_paths[:three], 'Shantyfile'))

        expect(subject.shantyfile_projects).to match_array([
          projects[:one],
          projects[:three]
        ])
      end

      it('executes the found Shantyfiles within the context of the project') do
        File.write(File.join(project_paths[:one], 'Shantyfile'), 'instance_variable_set(:@this_is_a_test, "foo")')
        File.write(File.join(project_paths[:three], 'Shantyfile'), 'instance_variable_set(:@this_is_a_test, "bar")')

        subject.shantyfile_projects

        expect(projects[:one].instance_variable_get(:@this_is_a_test)).to eq('foo')
        expect(projects[:three].instance_variable_get(:@this_is_a_test)).to eq('bar')
      end
    end
  end
end
