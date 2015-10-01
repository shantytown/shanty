require 'spec_helper'
require 'shanty/file_tree'

RSpec.describe(Shanty::FileTree) do
  include_context('workspace')
  subject { described_class.new(root) }

  before do
    [
      File.join(project_paths.first, 'Shantyfile'),
      # FIXME: Right now, the ignores are not procesed. This will be
      # implemented as part of issue #9.
      # File.join(project_paths[1], 'ignored'),
      File.join(project_paths[2], 'Shantyfile')
    ].each { |path| FileUtils.touch(path) }

    File.write(File.join(root, '.gitignore'), 'ignored')
  end

  describe('#files') do
    it('returns all the files within the root') do
      expect(subject.files).to match_array([
        File.join(root, 'Shantyconfig'),
        File.join(root, '.gitignore'),
        File.join(project_paths.first, 'Shantyfile'),
        File.join(project_paths[2], 'Shantyfile')
      ])
    end
  end

  describe('#glob') do
    it('returns all the files within the root that match any of the given globs') do
      expect(subject.glob('**/Shantyfile', 'badglob')).to match_array([
        File.join(project_paths.first, 'Shantyfile'),
        File.join(project_paths[2], 'Shantyfile')
      ])
    end
  end
end
