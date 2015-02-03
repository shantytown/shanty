require 'spec_helper'
require 'shanty/plugins/rspec_plugin'
require 'shanty/plugins/rubocop_plugin'
require 'shanty/discoverers/shantyfile_discoverer'

# All classes referenced belong to the shanty project
module Shanty
  RSpec.describe(ShantyfileDiscoverer) do
    include_context('basics')

    describe '#discover' do
      let(:project_template_paths) { ShantyfileDiscoverer.new(env).discover.map(&:path) }

      it 'finds projects with a Shantyfile' do
        expect(project_template_paths).to include(*project_paths.values)
      end
    end
  end
end
