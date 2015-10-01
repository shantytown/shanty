require 'spec_helper'
require 'shanty/plugins/rspec_plugin'

RSpec.describe(Shanty::Plugins::RspecPlugin) do
  include_context('plugin')

  it('adds the rspec tag automatically') do
    expect(described_class).to provide_tags(:rspec)
  end

  it('finds projects by calling a method to locate the ones that depend on Rspec') do
    expect(described_class).to provide_projects(:rspec_projects)
  end

  it('subscribes to the test event') do
    expect(described_class).to subscribe_to(:test).with(:rspec)
  end

  describe('#rspec_projects') do
    it('returns projects with a dependency on RSpec in a Gemfile') do
      gemfile_path = File.join(project_paths.first, 'Gemfile')
      File.write(gemfile_path, "gem 'rspec', '~> 1.2.3'")
      allow(file_tree).to receive(:glob).and_return([gemfile_path])

      expect(described_class.rspec_projects(env).map(&:path)).to contain_exactly(project_paths.first)
    end

    it('returns projects with a dependency on RSpec in a *.gemspec') do
      gemspec_path = File.join(project_paths[1], 'foo.gemspec')
      File.write(gemspec_path, "gem.add_dependency 'rspec', '~> 1.2.3")
      allow(file_tree).to receive(:glob).and_return([gemspec_path])

      expect(described_class.rspec_projects(env).map(&:path)).to contain_exactly(project_paths[1])
    end

    it('does not return projects with no dependency on RSpec') do
      gemfile_path = File.join(project_paths[2], 'Gemfile')
      File.write(gemfile_path, "gem 'foo', '~> 1.2.3'")
      allow(file_tree).to receive(:glob).and_return([gemfile_path])

      expect(described_class.rspec_projects(env)).to be_empty
    end
  end

  describe('#rspec') do
    it('calls rspec') do
      expect(subject).to receive(:system).with('rspec')

      subject.rspec
    end
  end
end
