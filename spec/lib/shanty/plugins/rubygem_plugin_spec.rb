require 'spec_helper'
require 'shanty/plugins/rubygem_plugin'

# All classes referenced belong to the shanty project
module Shanty
  RSpec.describe(RubygemPlugin) do
    include_context('basics')

    it('subscribes to the test event') do
      expect(RubygemPlugin.instance_variable_get(:@class_callbacks)).to include(build: [:build_gem])
    end

    describe('#build_gem') do
      it('calls gem build') do
        expect(subject).to receive(:system).with('gem build *.gemspec')

        subject.build_gem
      end
    end

    describe('#artifacts') do
      it('lists the project artifacts') do
        path = File.join(File.dirname(__FILE__), '..', '..', '..', '..')
        result = subject.artifacts(Project.new(path))

        expect(result.length).to eql(1)
        expect(File.dirname(result.first.to_local_path)).to eql(path)
        expect(result.first.file_extension).to eql('gem')
        expect(result.first.local?).to be true
        expect(result.first.uri.scheme).to eql('file')
      end
    end
  end
end
