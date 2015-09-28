require 'spec_helper'
require 'shanty/plugins/cucumber_plugin'

# All classes referenced belong to the shanty project
module Shanty
  RSpec.describe(CucumberPlugin) do
    include_context('graph')

    it('adds the cucumber tag') do
      expect(described_class).to add_tags(:cucumber)
    end

    it('finds projects by calling a method to locate the ones that depend on Cucumber') do
      expect(described_class).to define_projects.with(:cucumber_projects)
    end

    it('subscribes to the test event') do
      expect(described_class).to subscribe_to(:test).with(:cucumber)
    end

    describe('#cucumber_projects') do
      it('returns projects with a dependency on Cucumber in a Gemfile') do
        File.write(File.join(project_paths[:one], 'Gemfile'), "gem 'cucumber', '~> 1.2.3'")

        expect(subject.cucumber_projects).to match_array([projects[:one]])
      end

      it('returns projects with a dependency on Cucumber in a *.gemspec') do
        File.write(File.join(project_paths[:two], 'foo.gemspec'), "gem.add_dependency 'cucumber', '~> 1.2.3")

        expect(subject.cucumber_projects).to match_array([projects[:two]])
      end

      it('does not return projects with no dependency on Cucumber') do
        File.write(File.join(project_paths[:three], 'Gemfile'), "gem 'foo', '~> 1.2.3'")

        expect(subject.cucumber_projects).to be_empty
      end
    end

    describe('#cucumber') do
      it('calls cucumber') do
        expect(subject).to receive(:system).with('cucumber')

        subject.cucumber(project)
      end
    end
  end
end
