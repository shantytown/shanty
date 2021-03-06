require 'fileutils'
require 'i18n'
require 'shanty/env'
require 'shanty/file_tree'
require 'shanty/plugins/shantyfile_plugin'
require 'shanty/task_sets/basic_task_set'
require 'shanty/file_tree'
require 'spec_helper'
require 'tmpdir'

RSpec.describe(Shanty::Env) do
  subject(:env) { described_class.new }

  around do |example|
    Dir.mktmpdir('shanty-tests') do |tmp_path|
      Dir.chdir(tmp_path) do
        FileUtils.touch('Shantyconfig')
        example.run
      end
    end
  end

  describe('#root') do
    it('returns the path to the closest ancestor folder with a .shanty.yml file in it') do
      expect(env.root).to eql(Dir.pwd)
    end

    it('throws an exception if no ancestor folders have a .shanty.yml file in them') do
      FileUtils.rm('Shantyconfig')
      expect { env.root }.to raise_error(I18n.t('missing_root', config_file: described_class::CONFIG_FILE))
    end
  end

  describe('#file_tree') do
    it('returns a file tree') do
      expect(env.file_tree).to be_a(Shanty::FileTree)
    end
  end

  describe('#plugins') do
    it('defaults to just the Shantyfile plugin') do
      expect(env.plugins).to contain_exactly(Shanty::Plugins::ShantyfilePlugin)
    end
  end

  describe('#task_sets') do
    it('defaults to just the basic task set') do
      expect(env.task_sets).to contain_exactly(Shanty::TaskSets::BasicTaskSet)
    end
  end

  describe('#projects') do
    it('defaults to an empty hash') do
      expect(env.projects).to be_a(Hash)
      expect(env.projects).to be_empty
    end
  end

  describe('#config') do
    it('returns an empty hash for any missing keys') do
      expect(env.config[:foo]).to eql({})
    end
  end

  describe('#require') do
    it('calls require properly for anything passed in') do
      pending('need to check how we can capture the require calls')

      expect(env.singleton_class).to receive(:require).with('foo')

      env.require('foo')
    end

    it('captures any required plugins')

    it('captures any required task sets')
  end
end
