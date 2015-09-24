require 'shanty/project'
require_fixture 'test_plugin'

module Shanty
  # Test Project fixture which includes the test Plugin.
  class TestProjectWithPlugin < Project
    def initialize(path)
      super(path)
      @plugins = [TestPlugin.new]
    end
  end
end
