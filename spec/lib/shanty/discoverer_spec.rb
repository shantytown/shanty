require 'spec_helper'
require 'shanty/discoverer'
require_fixture 'test_discoverer'

# All classes referenced belong to the shanty project
module Shanty
  RSpec.describe(Discoverer) do
    include_context('graph')
    subject { Discoverer.new(env) }
    let(:discoverer_class) { Class.new(TestDiscoverer) }
    let(:discoverer) { discoverer_class.new(env) }

    describe('.inheriteded') do
      it('adds the inheriting discoverer to the array of registered discoverers') do
        Discoverer.inherited(discoverer_class)

        expect(Discoverer.instance_variable_get(:@discoverers)).to include(discoverer_class)
      end
    end

    describe('.discoverers') do
      it('returns any registered discoverers') do
        expect(Discoverer.discoverers).to include(TestDiscoverer)
      end
    end

    describe('#discover_all') do
      let(:priority_project_template) { project_template.dup.priority(1000) }
      let(:other_project_template) { project_templates[:one] }

      it('calls discover on all discoverers') do
        Discoverer.instance_variable_get(:@discoverers).each do |discoverer_class|
          expect(discoverer_class).to receive(:new).and_return(discoverer)
          expect(discoverer).to receive(:discover).and_return([])
        end

        subject.discover_all
      end

      it('returns an array of all discovered project templates') do
        expect(subject.discover_all.map(&:path)).to include(*project_paths.values)
      end

      it('sorts the projects by priority, highest priority first') do
        Discoverer.instance_variable_get(:@discoverers).each do |discoverer_class|
          allow(discoverer_class).to receive(:new).and_return(discoverer)
          allow(discoverer).to receive(:discover).and_return([other_project_template, priority_project_template])
        end

        expect(subject.discover_all).to eql([priority_project_template, other_project_template])
      end

      it('removes duplicate project templates for a specific path') do
        Discoverer.instance_variable_get(:@discoverers).each do |discoverer_class|
          expect(discoverer_class).to receive(:new).and_return(discoverer)
          expect(discoverer).to receive(:discover).and_return([priority_project_template])
        end

        expect(subject.discover_all).to eql([priority_project_template])
      end
    end
  end
end
