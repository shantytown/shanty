require 'coveralls'
Coveralls.wear!

require 'fileutils'
require 'i18n'
require 'tmpdir'
require 'shanty/env'
require 'shanty/graph'
require 'shanty/project'
require 'shanty/task_env'
require 'shanty/plugins/rspec_plugin'
require 'shanty/plugins/rubocop_plugin'
require 'shanty/plugins/shantyfile_plugin'

def require_fixture(path)
  require File.join(__dir__, 'fixtures', path)
end

require_fixture 'test_plugin'

I18n.enforce_available_locales = false

RSpec.configure do |config|
  config.mock_with(:rspec) do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.before(:example) do
    Shanty::Env.clear!
    Shanty::TaskEnv.clear!
    Shanty::Project.clear!
  end
end

RSpec.shared_context('basics') do
  around(:each) do |example|
    # FIXME: The TaskEnv spec currently blows up without this because
    # gitignore_rb cannot handle not having a `.gitignore` file present. This
    # needs to be fixed.
    FileUtils.touch(File.join(root, '.gitignore'))
    FileUtils.touch(File.join(root, '.shanty.yml'))
    project_paths.values.each do |project_path|
      FileUtils.mkdir_p(project_path)
    end

    Dir.chdir(root) do
      example.run
    end

    FileUtils.rm_rf(root)
  end

  let(:root) { Dir.mktmpdir('shanty-test') }
  let(:project_paths) do
    {
      one: File.join(root, 'one'),
      two: File.join(root, 'two'),
      three: File.join(root, 'two', 'three')
    }
  end
  let(:project_path) { project_paths[:one] }
end

RSpec.shared_context('graph') do
  include_context('basics')

  let(:projects) do
    project_paths.each_with_object({}) do |(key, project_path), acc|
      acc[key] = Shanty::Project.new(project_path)
    end
  end
  let(:project) { projects[:one] }
  let(:project_path_trie) do
    Containers::Trie.new.tap do |trie|
      projects.values.map { |project| trie[project.path] = project }
    end
  end
  let(:graph) { Shanty::Graph.new(project_path_trie, projects.values) }
end
