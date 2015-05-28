require 'coveralls'
Coveralls.wear!

require 'i18n'
require 'shanty/env'
require 'shanty/graph'
require 'shanty/project'
require 'shanty/plugins/rspec_plugin'
require 'shanty/plugins/rubocop_plugin'

def require_fixture(path)
  require File.join(__dir__, 'fixtures', path)
end

require_fixture 'test_plugin'

I18n.enforce_available_locales = false

RSpec.configure do |config|
  config.mock_with(:rspec) do |mocks|
    mocks.verify_partial_doubles = true
  end
end

RSpec.shared_context('basics') do
  let(:env) { Shanty::Env.new }
  let(:root) { File.expand_path(File.join(__dir__, '..')) }
  let(:project_paths) do
    {
      three: File.join(root, 'examples', 'test-static-project-2', 'test-static-project-3'),
      two: File.join(root, 'examples', 'test-static-project-2'),
      one: File.join(root, 'examples', 'test-static-project'),
      shanty: File.join(root)
    }
  end
  let(:project_path) { project_paths[:shanty] }
end

RSpec.shared_context('graph') do
  include_context('basics')

  let(:projects) do
    Hash[project_paths.map do |key, project_path|
      [key, Shanty::Project.new(env, project_path).tap do |project|
        project.plugin(Shanty::TestPlugin)
        project.execute_shantyfile!
      end]
    end]
  end
  let(:project) { projects[:shanty] }
  let(:project_path_trie) do
    Containers::Trie.new.tap do |trie|
      projects.values.map { |project| trie[project.path] = project }
    end
  end
  let(:graph) { Shanty::Graph.new(project_path_trie, projects.values) }
end
