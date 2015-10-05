require 'active_support/core_ext/hash/indifferent_access'
require 'spec_helper'
require 'shanty/plugin'

RSpec.describe(Shanty::Plugin) do
  include_context('workspace')

  subject { plugin_class.new(env, project) }
  let(:plugin_class) { Class.new(described_class) }
  let(:env) { double('env') }
  let(:project) { double('project') }

  describe('.name') do
    it('gets the name of the class') do
      expect(plugin_class.name).to eql(plugin_class.to_s.downcase.to_sym)
    end
  end

  describe('.info') do
    it('info to contain information on the plugin') do
      expect(plugin_class.info).to eql(name: plugin_class.name,
                                       description: nil,
                                       tags: [plugin_class.name],
                                       subscribes: [],
                                       config: {})
    end
  end

  describe('.projects') do
    before do
      allow(env).to receive(:file_tree).and_return(file_tree)
      allow(env).to receive(:projects).and_return({})
      allow(env).to receive(:root).and_return(root)
      allow(file_tree).to receive(:glob).and_return([])
      allow(project).to receive(:add_plugin)

      plugin_class.define_singleton_method(:foo) { |_| [] }
    end

    let(:file_tree) { double('file tree') }
    let(:project) { double('project') }

    it('returns no projects if there are no matchers') do
      expect(plugin_class.projects(env)).to be_empty
    end

    it('returns projects matching any stored globs') do
      paths = project_paths.map { |p| File.join(p, 'foo') }
      plugin_class.project_globs.concat(['**/foo', '**/bar'])
      allow(file_tree).to receive(:glob).with('**/foo', '**/bar').and_return(paths)

      expect(plugin_class.projects(env).map(&:path)).to match_array(project_paths)
    end

    it('returns projects provided by the stored callbacks') do
      allow(plugin_class).to receive(:foo).and_return([project])
      plugin_class.project_providers << :foo

      expect(plugin_class.projects(env)).to match_array([project])
    end

    it('adds the current plugin to the project') do
      allow(plugin_class).to receive(:foo).and_return([project])
      plugin_class.project_providers << :foo

      expect(project).to receive(:add_plugin).with(plugin_class)

      plugin_class.projects(env)
    end
  end

  describe('#artifacts') do
    it('returns no artifacts when artifacts have not been implemented') do
      expect(subject.artifacts(project)).to be_empty
    end
  end

  describe('#config') do
    before(:each) do
      allow(env).to receive(:config).and_return(
        HashWithIndifferentAccess.new { |h, k| h[k] = HashWithIndifferentAccess.new }
      )
      allow(project).to receive(:config).and_return(
        HashWithIndifferentAccess.new { |h, k| h[k] = HashWithIndifferentAccess.new }
      )
    end

    it('returns nothing when no configuration set') do
      expect(subject.config[:nic]).to be_empty
    end

    it('retuns valid config when set in the project') do
      project.config[plugin_class.name][:nic] = 'cage'

      expect(subject.config[:nic]).to eql('cage')
    end

    it('returns valid config when set in the env') do
      env.config[plugin_class.name][:nic] = 'cage'

      expect(subject.config[:nic]).to eql('cage')
    end

    it('returns valid config when set in the plugin') do
      plugin_class.config[:nic] = 'cage'

      expect(subject.config[:nic]).to eql('cage')
    end
  end
end
