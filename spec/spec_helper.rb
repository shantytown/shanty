require 'coveralls'
Coveralls.wear!

require 'i18n'
require 'shanty/env'
require 'shanty/graph'
require 'shanty/project_template'
require 'shanty/plugins/rspec_plugin'
require 'shanty/plugins/rubocop_plugin'

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
end

RSpec.shared_context('graph') do
  include_context('basics')

  let(:project_templates) do
    Hash[project_paths.map do |key, project_path|
      [key, Shanty::ProjectTemplate.new(env, project_path).setup!]
    end]
  end
  let(:project_template) { project_templates[:shanty] }
  let(:graph) { Shanty::Graph.new(env, project_templates.values) }
end

def require_fixture(path)
  require File.join(__dir__, 'fixtures', path)
end
