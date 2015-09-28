require 'spec_helper'
require 'tmpdir'
require 'shanty/graph'
require 'shanty/project'

# Allows all classes to be refereneced without the module name
module Shanty
  RSpec.describe(Graph) do
    include_context('graph')
    subject { graph }

    describe('#each') do
      it('returns the projects exactly as passed in') do
        expect(subject.each.to_a).to eql(projects.values)
      end
    end

    describe('#by_name') do
      it('returns nil when finding a name that does not exist') do
        expect(subject.by_name('foobarlux')).to be_nil
      end

      it('returns the correct project when finding a name that does exist') do
        expect(subject.by_name(subject.first.name)).to equal(subject.first)
      end
    end

    describe('#all_with_tags') do
      before do
        subject.first.tags << 'test'
      end

      it('returns an empty array when no tags are given') do
        expect(subject.all_with_tags).to be_empty
      end

      it('returns an empty array when no projects match the tags given') do
        expect(subject.all_with_tags('foo')).to be_empty
      end

      it('returns the correct projects when matching tags are given') do
        expect(subject.all_with_tags('test')).to match_array([subject.first])
      end
    end

    describe('#changed') do
      it('returns all the changed projects') do
        allow(projects[:one]).to receive(:changed?).and_return(true)
        allow(projects[:two]).to receive(:changed?).and_return(false)
        allow(projects[:three]).to receive(:changed?).and_return(true)

        expect(subject.changed).to match_array([projects[:one], projects[:three]])
      end
    end

    describe('#owner_of_file') do
      it('returns nil if the given folder is outside of any project') do
        expect(subject.owner_of_file('/tmp')).to be_nil
      end

      it('returns the correct project that owns a given folder') do
        expect(subject.owner_of_file(project_paths[:three]).path).to eql(project_paths[:three])
      end
    end

    describe('#projects_within_path') do
      let(:projects_within_path) { subject.projects_within_path(project_paths[:two]) }

      it('returns all the projects at or below the given path') do
        expect(projects_within_path.map(&:path)).to contain_exactly(project_paths[:two], project_paths[:three])
      end
    end
  end
end
