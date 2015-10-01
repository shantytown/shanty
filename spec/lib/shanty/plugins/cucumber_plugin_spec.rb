require 'spec_helper'
require 'shanty/plugins/cucumber_plugin'

RSpec.describe(Shanty::Plugins::CucumberPlugin) do
  include_context('plugin')

  it('adds the cucumber tag automatically') do
    expect(described_class).to provide_tags(:cucumber)
  end

  it('finds projects by calling a method to locate the ones that depend on Cucumber') do
    expect(described_class).to provide_projects(:cucumber_projects)
  end

  it('subscribes to the test event') do
    expect(described_class).to subscribe_to(:test).with(:cucumber)
  end

  describe('#cucumber_projects') do
    it('returns projects with a dependency on Cucumber in a Gemfile') do
      gemfile_path = File.join(project_paths.first, 'Gemfile')
      File.write(gemfile_path, "gem 'cucumber', '~> 1.2.3'")
      allow(file_tree).to receive(:glob).and_return([gemfile_path])

      expect(described_class.cucumber_projects(env).map(&:path)).to contain_exactly(project_paths.first)
    end

    it('returns projects with a dependency on Cucumber in a *.gemspec') do
      gemspec_path = File.join(project_paths[1], 'foo.gemspec')
      File.write(gemspec_path, "gem.add_dependency 'cucumber', '~> 1.2.3")
      allow(file_tree).to receive(:glob).and_return([gemspec_path])

      expect(described_class.cucumber_projects(env).map(&:path)).to contain_exactly(project_paths[1])
    end

    it('does not return projects with no dependency on Cucumber') do
      gemfile_path = File.join(project_paths[2], 'Gemfile')
      File.write(gemfile_path, "gem 'foo', '~> 1.2.3'")
      allow(file_tree).to receive(:glob).and_return([gemfile_path])

      expect(described_class.cucumber_projects(env)).to be_empty
    end
  end

  describe('#cucumber') do
    it('calls cucumber') do
      expect(subject).to receive(:system).with('cucumber')

      subject.cucumber
    end
  end
end
