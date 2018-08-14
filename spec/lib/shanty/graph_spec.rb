require 'spec_helper'
require 'shanty/graph'

RSpec.describe(Shanty::Graph) do
  subject { described_class.new(project_path_trie, projects) }

  let(:project_path_trie) { double('project path trie') }
  let(:projects) do
    [
      double('project one'),
      double('project two'),
      double('project three')
    ]
  end

  describe('#each') do
    it('returns the projects exactly as passed in') do
      expect(subject.each.to_a).to eql(projects)
    end
  end

  describe('#by_name') do
    before do
      allow(projects.first).to receive(:name).and_return('foo')
      allow(projects[1]).to receive(:name).and_return('bar')
      allow(projects[2]).to receive(:name).and_return('lux')
    end

    it('returns nil when finding a name that does not exist') do
      expect(subject.by_name('foobarlux')).to be_nil
    end

    it('returns the correct project when finding a name that does exist') do
      expect(subject.by_name('foo')).to equal(projects.first)
    end
  end

  describe('#all_with_tags') do
    before do
      allow(projects.first).to receive(:all_tags).and_return([:foo])
      allow(projects[1]).to receive(:all_tags).and_return(%i[foo bar])
      allow(projects[2]).to receive(:all_tags).and_return([:lux])
    end

    it('returns an empty array when no tags are given') do
      expect(subject.all_with_tags).to be_empty
    end

    it('returns an empty array when no projects match the tags given') do
      expect(subject.all_with_tags(:foobarlux)).to be_empty
    end

    it('returns the correct projects when matching tags are given') do
      expect(subject.all_with_tags(:foo)).to contain_exactly(projects.first, projects[1])
    end

    it('converts the given tags to symbols when checking for matches') do
      expect(subject.all_with_tags('bar')).to contain_exactly(projects[1])
    end
  end

  describe('#changed') do
    before do
      allow(projects.first).to receive(:changed?).and_return(true)
      allow(projects[1]).to receive(:changed?).and_return(false)
      allow(projects[2]).to receive(:changed?).and_return(true)
    end

    it('returns all the changed projects') do
      expect(subject.changed).to contain_exactly(projects.first, projects[2])
    end
  end

  describe('#owner_of_file') do
    it('returns nil if the given folder is outside of any project') do
      allow(project_path_trie).to receive(:longest_prefix)
      allow(project_path_trie).to receive(:[])

      expect(subject.owner_of_file('/tmp')).to be_nil
    end

    it('returns the correct project that owns a given folder') do
      allow(project_path_trie).to receive(:longest_prefix).with('/foo/bar').and_return('/foo')
      allow(project_path_trie).to receive(:[]).with('/foo').and_return(projects.first)

      expect(subject.owner_of_file('/foo/bar')).to eql(projects.first)
    end
  end

  describe('#projects_within_path') do
    before do
      allow(projects.first).to receive(:path).and_return('/foo')
      allow(projects[1]).to receive(:path).and_return('/foo/bar')
      allow(projects[2]).to receive(:path).and_return('/lux')
    end

    it('returns all the projects at or below the given path') do
      expect(subject.projects_within_path('/foo')).to contain_exactly(projects.first, projects[1])
    end
  end
end
