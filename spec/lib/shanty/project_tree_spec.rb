require 'spec_helper'
require 'shanty/plugin'

# All classes referenced belong to the shanty project
module Shanty
  RSpec.describe(ProjectTree) do
    include_context('basics')
    subject { described_class.new(root) }

    before do
      [
        File.join(project_paths[:one], 'Shantyfile'),
        # FIXME: Right now, the ignores are not procesed. This will be
        # implemented as part of issue #9.
        # File.join(project_paths[:two], 'ignored'),
        File.join(project_paths[:three], 'Shantyfile')
      ].each { |path| FileUtils.touch(path) }

      File.write(File.join(root, '.gitignore'), 'ignored')
    end

    describe('#files') do
      it('returns all the files within the root') do
        expect(subject.files).to match_array([
          File.join(root, '.shanty.yml'),
          File.join(root, '.gitignore'),
          File.join(project_paths[:one], 'Shantyfile'),
          File.join(project_paths[:three], 'Shantyfile')
        ])
      end
    end

    describe('#glob') do
      it('returns all the files within the root that match any of the given globs') do
        expect(subject.glob('**/Shantyfile', 'badglob')).to match_array([
          File.join(project_paths[:one], 'Shantyfile'),
          File.join(project_paths[:three], 'Shantyfile')
        ])
      end
    end
  end
end
