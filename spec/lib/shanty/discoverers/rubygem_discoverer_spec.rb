require 'spec_helper'
require 'shanty/plugins/rspec_plugin'
require 'shanty/plugins/rubocop_plugin'
require 'shanty/discoverers/rubygem_discoverer'

# All classes referenced belong to the shanty project
module Shanty
  RSpec.describe(RubygemDiscoverer) do
    include_context('basics')

    describe '#discover' do
      let(:project_template_paths) { RubygemDiscoverer.new(env).discover.map(&:path) }

      it 'finds rubygem projects' do
        expect(project_template_paths).to include(project_paths[:shanty])
      end
    end
  end
end
