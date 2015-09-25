require 'shanty/config'
require 'shenanigans/hash/to_ostruct'
require 'deep_merge'

# All classes referenced belong to the shanty project
module Shanty
  RSpec.describe(Config) do
    subject { Config.new('nic', 'test') }

    let(:subconfig) { { 'kim' => 'cage' } }
    let(:config) { { 'nic' => subconfig } }
    let(:env_config) { { 'test' => config } }

    before do
      allow(File).to receive(:exist?) { true }
      allow(YAML).to receive(:load_file) { env_config }
    end

    describe(Config) do
      it('can respond like an OpenStruct') do
        expect(subject.nic).to eql(subconfig.to_ostruct)
      end

      it('handles no config file existing') do
        allow(File).to receive(:exist?) { false }
        expect(subject.nic).to eql(OpenStruct.new)
      end

      it('handles no data in the config file') do
        allow(YAML).to receive(:load_file) { false }
        expect(subject.nic).to eql(OpenStruct.new)
      end

      it('loads config from a file') do
        allow(File).to receive(:exist?).and_call_original
        allow(YAML).to receive(:load_file).and_call_original
        Dir.mktmpdir('shanty-tests') do |tmp_path|
          Dir.chdir(tmp_path) { FileUtils.touch('.shanty.yml') }
          expect(Config.new(tmp_path, 'test').nic).to eql(OpenStruct.new)
        end
      end

      it('returns nothing if .shanty.yml does not exist') do
        allow(File).to receive(:exist?).and_call_original
        allow(YAML).to receive(:load_file).and_call_original
        expect(subject.nic).to eql(OpenStruct.new)
      end
    end

    describe('#[]') do
      it('can respond like a hash') do
        expect(subject['nic']).to eql(subconfig.to_ostruct)
      end
    end

    describe('merge!') do
      it('can merge in new config') do
        added_config = { 'copolla' => 'cage' }
        subject.merge!('nic' => added_config)

        expect(subject['nic']).to eql(subconfig.deep_merge(added_config).to_ostruct)
      end
    end
  end
end
