require 'shanty/project'
require_fixture 'test_plugin'

module Shanty
  # Test Project fixture which includes the test Plugin.
  class TestProjectWithPlugin < Project
    include TestPlugin

    def initialize; end
  end
end
