require 'spec_helper'
require 'tmpdir'
require 'shanty/graph'
require 'shanty/project'

require_fixture 'test_plugin'
require_fixture 'test_unused_plugin'

# Allows all classes to be refereneced without the module name
module Shanty
  RSpec.describe(Graph) do
    include_context('graph')
    subject { graph }

    describe('.new') do
      let(:missing_parent) { 'foo-bar-does-not-exist' }
      it('throws an exception if any of the projects have a dependency on a project that does not exist') do
        project_templates[:shanty].parent(missing_parent)

        expect { subject }.to raise_error("Cannot find project at path #{File.join(root, missing_parent)}, which was "\
          'specified as a dependency for shanty')
      end
    end

    describe('enumerable methods') do
      it('returns projects linked together with parent relationships') do
        expect(subject[0].parents.map(&:path)).to eql([])
        expect(subject[1].parents.map(&:path)).to eql([project_paths[:one]])
        expect(subject[2].parents.map(&:path)).to eql([project_paths[:two]])
      end

      it('returns projects linked together with child relationships') do
        expect(subject[0].children.map(&:path)).to eql([project_paths[:two]])
        expect(subject[1].children.map(&:path)).to eql([project_paths[:three]])
        expect(subject[2].children.map(&:path)).to eql([])
      end

      it("returns projects sorted using Tarjan's strongly connected components algorithm") do
        expect(subject[0].path).to equal(project_paths[:one])
        expect(subject[1].path).to equal(project_paths[:two])
        expect(subject[2].path).to equal(project_paths[:three])
      end
    end

    describe('#changed') do
      it('returns only projects where #changed? is true') do
        subject.first.changed = true

        expect(subject.changed).to contain_exactly(subject.first)
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

    describe('#all_with_plugin') do
      it('returns an empty array when no plugins are given') do
        expect(subject.all_with_plugin).to be_empty
      end

      it('returns an empty array when no projects match the plugins given') do
        expect(subject.all_with_plugin(UnusedPlugin)).to be_empty
      end

      it('returns the correct projects when matching plugins are given') do
        expect(subject.all_with_plugin(TestPlugin)).to match_array(subject)
      end
    end

    describe('#changed_with_plugin') do
      before do
        subject.first.changed = true
      end

      it('returns an empty array when no types are given') do
        expect(subject.changed_with_plugin).to be_empty
      end

      it('returns an empty array when no projects match the types given') do
        expect(subject.changed_with_plugin(UnusedPlugin)).to be_empty
      end

      it('returns the correct projects when matching types are given') do
        expect(subject.changed_with_plugin(TestPlugin)).to contain_exactly(subject.first)
      end
    end

    describe('#owner_of_file') do
      it('returns nil if the given folder is outside of any project') do
        expect(subject.owner_of_file('/tmp')).to be_nil
      end

      it('returns the correct project that owns a given folder') do
        expect(subject.owner_of_file(project_paths[:three]).path).to equal(project_paths[:three])
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
