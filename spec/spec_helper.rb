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
