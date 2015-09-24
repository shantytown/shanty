require 'spec_helper'
require 'shanty/project'

require_fixture 'test_plugin'

# All classes referenced belong to the shanty project
module Shanty
  RSpec.describe(Project) do
    include_context('graph')
    subject { Shanty::Project.new(project_path) }

    describe('#name') do
      it('returns the name from the project template in the constructor') do
        expect(subject.name).to eql('one')
      end
    end

    describe('#path') do
      it('returns the path from the project template in the constructor') do
        expect(subject.path).to eql(project_path)
      end
    end

    describe('#options') do
      it('defaults the options to an empty object') do
        expect(subject.options).to eql({})
      end
    end

    describe('#parents_by_path') do
      it('defaults the parents to an empty array') do
        expect(subject.parents_by_path).to eql([])
      end
    end

    describe('#artifact_paths') do
      it('defaults the paths to an empty array') do
        expect(subject.artifact_paths).to eql([])
      end
    end

    describe('#to_s') do
      it('returns a simple string representation of the project') do
        expect(subject.to_s).to eql('one')
      end
    end

    describe('#inspect') do
      it('returns a detailed string representation of the project') do
        expect(subject.inspect).to eql({
          name: 'one',
          path: project_path,
          tags: [],
          options: {},
          parents_by_path: []
        }.inspect)
      end
    end
  end
end
