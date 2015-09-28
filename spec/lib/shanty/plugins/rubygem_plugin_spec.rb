require 'spec_helper'
require 'fileutils'
require 'shanty/plugins/rubygem_plugin'

# All classes referenced belong to the shanty project
module Shanty
  RSpec.describe(RubygemPlugin) do
    include_context('graph')
    let(:gemspec_path) { File.join(project_path, 'foo.gemspec') }

    before do
      File.write(gemspec_path, <<-eof)
        Gem::Specification.new do |gem|
          gem.name = 'foo'
          gem.version = '1.2.3'
        end
      eof
    end

    it('adds the gem tag') do
      expect(described_class).to add_tags(:gem)
    end

    it('adds the rubygem tag automatically') do
      expect(described_class.tags).to match_array([:rubygem, :gem])
    end

    it('finds projects that have a *.gemspec file') do
      expect(described_class).to define_projects.with('**/*.gemspec')
    end

    it('subscribes to the build event') do
      expect(described_class).to subscribe_to(:build).with(:build_gem)
    end

    describe('#build_gem') do
      it('calls gem build') do
        expect(subject).to receive(:system).with("gem build #{gemspec_path}")

        subject.build_gem(project)
      end
    end

    describe('#artifacts') do
      let(:gem_path) { File.join(project_path, 'foo-1.2.3.gem') }

      it('lists the project artifacts') do
        result = subject.artifacts(project)

        expect(result.length).to eql(1)
        expect(result.first.to_local_path).to eql(gem_path)
        expect(result.first.file_extension).to eql('gem')
        expect(result.first.local?).to be true
        expect(result.first.uri.scheme).to eql('file')
      end
    end
  end
end
