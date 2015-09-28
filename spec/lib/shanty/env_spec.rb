require 'spec_helper'
require 'fileutils'
require 'i18n'
require 'tmpdir'
require 'shanty/env'
require 'shenanigans/hash/to_ostruct'
require 'deep_merge'

# All classes referenced belong to the shanty project
module Shanty
  RSpec.describe(Env) do
    around do |example|
      Dir.mktmpdir('shanty-tests') do |tmp_path|
        Dir.chdir(tmp_path) do
          FileUtils.touch('.shanty.yml')
          example.run
        end
      end
    end

    describe('#require!') do
      let(:file_config) { { 'local' => { 'require' => ['foo', 'bar.foo'] } } }
      let(:glob_config) { { 'local' => { 'require' => ['**/*.foo'] } } }
      let(:dir_config) { { 'local' => { 'require' => ['lux'] } } }

      before do
        FileUtils.touch(['foo', 'bar.foo'])
        FileUtils.mkdir('lux')
        FileUtils.touch(['lux/luxy.rb', 'lux/floxy.rb', 'lux/luxoo.foo'])
      end

      it('requires nothing when there is no "require" config entry') do
        expect(subject).to_not receive(:require)

        subject.require!
      end

      it('requires entries that are files') do
        allow(YAML).to receive(:load_file) { file_config }

        expect(subject).to receive(:require).with(File.join(Dir.pwd, 'foo'))
        expect(subject).to receive(:require).with(File.join(Dir.pwd, 'bar.foo'))

        subject.require!
      end

      it('requires entries that are globs') do
        allow(YAML).to receive(:load_file) { glob_config }

        expect(subject).to receive(:require).with(File.join(Dir.pwd, 'bar.foo'))
        expect(subject).to receive(:require).with(File.join(Dir.pwd, 'lux/luxoo.foo'))

        subject.require!
      end

      it('requires entries that are directories') do
        allow(YAML).to receive(:load_file) { dir_config }

        expect(subject).to receive(:require).with(File.join(Dir.pwd, 'lux/luxy.rb'))
        expect(subject).to receive(:require).with(File.join(Dir.pwd, 'lux/floxy.rb'))

        subject.require!
      end
    end

    describe('#logger') do
      it('returns a logger object') do
        expect(subject.logger).to be_a(Logger)
      end
    end

    describe('#environment') do
      before do
        ENV.delete('SHANTY_ENV')
      end

      it('returns the SHANTY_ENV environment variable if set') do
        ENV['SHANTY_ENV'] = 'foo'
        expect(subject.environment).to eql('foo')
      end

      it('returns local if SHANTY_ENV is not set') do
        expect(subject.environment).to eql('local')
      end
    end

    describe('#build_number') do
      before do
        ENV.delete('SHANTY_BUILD_NUMBER')
      end

      it('returns the SHANTY_BUILD_NUMBER environment variable if set') do
        ENV['SHANTY_BUILD_NUMBER'] = '123'
        expect(subject.build_number).to eql(123)
      end

      it('returns 1 if SHANTY_BUILD_NUMBER is not set') do
        expect(subject.build_number).to eql(1)
      end
    end

    describe('#root') do
      it('returns the path to the closest ancestor folder with a .shanty.yml file in it') do
        expect(subject.root).to eql(Dir.pwd)
      end

      it('throws an exception if no ancestor folders have a .shanty.yml file in them') do
        FileUtils.rm('.shanty.yml')
        expect { subject.root }.to raise_error(I18n.t('missing_root', config_file: Env::CONFIG_FILE))
      end
    end

    describe('#config') do
      before do
        ENV['SHANTY_ENV'] = 'stray_cats'
      end

      it('handles no config file existing') do
        allow(File).to receive(:exist?) { false }
        expect(subject.config.nic).to eql(OpenStruct.new)
      end

      it('handles no data in the config file') do
        allow(YAML).to receive(:load_file) { false }
        expect(subject.config)
      end

      it('returns nothing if .shanty.yml does not exist') do
        FileUtils.rm('.shanty.yml')
        expect(subject.config.nic).to eql(OpenStruct.new)
      end
    end
  end
end
