require 'simplecov'
require 'coveralls'

SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
  add_filter '/spec/'
end

require 'fileutils'
require 'i18n'
require 'logger'
require 'pathname'
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

def require_matchers(path)
  require File.join(__dir__, 'support', 'matchers', path)
end

require_matchers 'call_me_ruby'
require_matchers 'plugin'

I18n.enforce_available_locales = false
I18n.load_path = Dir[File.expand_path(File.join(__dir__, '..', 'translations', '*.yml'))]

RSpec.configure do |config|
  config.expect_with(:rspec) do |c|
    c.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with(:rspec) do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.before(:example) do
    Shanty::Env.clear!
    Shanty::TaskEnv.clear!
    Shanty::Project.clear!
    Shanty::Env.logger.level = Logger::ERROR
  end
end

RSpec.shared_context('basics') do
  around do |example|
    FileUtils.touch(File.join(root, '.shanty.yml'))
    project_paths.values.each do |project_path|
      FileUtils.mkdir_p(project_path)
    end

    Dir.chdir(root) do
      example.run
    end

    FileUtils.rm_rf(root)
  end

  # We have to use `realpath` for this as, at least on Mac OS X, the temporary
  # dir path that is returned is actually a symlink. Shanty resolves this
  # internally, so if we want to compare to any of the paths correctly we'll
  # need to resolve it too.
  let(:root) { Pathname.new(Dir.mktmpdir('shanty-test')).realpath }
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
