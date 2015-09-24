require 'spec_helper'
require 'shanty/plugin'

require_fixture 'test_plugin'
require_fixture 'test_project_with_plugin'

# All classes referenced belong to the shanty project
module Shanty
  RSpec.describe(Plugin) do
    include_context('basics')
    subject { TestPlugin }
    let(:project) { TestProjectWithPlugin.new(project_path) }
    let(:callbacks) { [%i(foo bar), %i(cats dogs rabies)] }

    # FIXME: Actuall test Plugin now.
  end
end
