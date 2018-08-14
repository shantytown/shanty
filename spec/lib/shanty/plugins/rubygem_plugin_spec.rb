require 'spec_helper'
require 'fileutils'
require 'shanty/plugins/rubygem_plugin'

RSpec.describe(Shanty::Plugins::RubygemPlugin) do
  include_context('with plugin')
  let(:gemspec_path) { File.join(project_path, 'foo.gemspec') }

  before do
    allow(file_tree).to receive(:glob).and_return([gemspec_path])
    allow(project).to receive(:path).and_return(project_paths.first)

    File.write(gemspec_path, <<-GEMSPEC)
      Gem::Specification.new do |gem|
        gem.name = 'foo'
        gem.version = '1.2.3'
      end
    GEMSPEC
  end

  it('adds the gem tag') do
    expect(described_class).to provide_tags(:rubygem, :gem)
  end

  it('adds the rubygem tag automatically') do
    expect(described_class).to provide_tags(:rubygem)
  end

  it('finds projects that have a *.gemspec file') do
    expect(described_class).to provide_projects_containing('**/*.gemspec')
  end

  it('subscribes to the build event') do
    expect(described_class).to subscribe_to(:build).with(:build_gem)
  end

  describe('#build_gem') do
    it('calls gem build') do
      expect(subject).to receive(:system).with("gem build #{gemspec_path}")

      subject.build_gem
    end
  end

  describe('#artifacts') do
    let(:gem_path) { File.join(project_path, 'foo-1.2.3.gem') }

    it('lists the project artifacts') do
      result = subject.artifacts

      expect(result.length).to be(1)
      expect(result.first.to_local_path).to eq(gem_path)
      expect(result.first.file_extension).to eq('gem')
      expect(result.first.local?).to be(true)
      expect(result.first.uri.scheme).to eq('file')
    end
  end
end
