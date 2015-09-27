require 'fileutils'
require 'spec_helper'
require 'shanty/plugins/rspec_plugin'

# All classes referenced belong to the shanty project
module Shanty
  RSpec.describe(RspecPlugin) do
    include_context('graph')

    it('adds the rspec tag') do
      expect(described_class).to add_tags(:rspec)
    end

    it('finds projects by calling a method to locate the ones that depend on RSpec') do
      expect(described_class).to define_projects.with(:rspec_projects)
    end

    it('subscribes to the test event') do
      expect(described_class).to subscribe_to(:test).with(:rspec)
    end

    describe('#rspec_projects') do
      it('returns projects with a dependency on RSpec in a Gemfile') do
        File.write(File.join(project_paths[:one], 'Gemfile'), "gem 'rspec', '~> 1.2.3'")

        expect(subject.rspec_projects).to match_array([projects[:one]])
      end

      it('returns projects with a dependency on RSpec in a *.gemspec') do
        File.write(File.join(project_paths[:two], 'foo.gemspec'), "gem.add_dependency 'rspec', '~> 1.2.3")

        expect(subject.rspec_projects).to match_array([projects[:two]])
      end

      it('does not return projects with no dependency on RSpec') do
        File.write(File.join(project_paths[:three], 'Gemfile'), "gem 'foo', '~> 1.2.3'")

        expect(subject.rspec_projects).to be_empty
      end
    end

    describe('#rspec') do
      it('calls rspec') do
        expect(subject).to receive(:system).with('rspec')

        subject.rspec
      end
    end
  end
end
