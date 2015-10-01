require 'coveralls'
require 'fileutils'
require 'i18n'
require 'logger'
require 'pathname'
require 'simplecov'
require 'tmpdir'

require_relative 'support/contexts/plugin'
require_relative 'support/contexts/workspace'
require_relative 'support/matchers/call_me_ruby'
require_relative 'support/matchers/plugin'

SimpleCov.formatter = Coveralls::SimpleCov::Formatter
SimpleCov.start do
  add_filter '/spec/'
end

I18n.enforce_available_locales = false
I18n.load_path = Dir[File.expand_path(File.join(__dir__, '..', 'translations', '*.yml'))]

RSpec.configure do |config|
  config.expect_with(:rspec) do |c|
    c.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with(:rspec) do |mocks|
    mocks.verify_partial_doubles = true
  end
end

RSpec.shared_context('') do
  around do |example|
    FileUtils.touch(File.join(root, '.shanty.yml'))
    project_paths.each do |project_path|
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
  let(:project_path) { project_paths.first }
end
