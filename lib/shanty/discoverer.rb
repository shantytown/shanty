require 'shanty/project_template'

module Shanty
  class Discoverer
    @@discoverers = []

    def self.inherited(discoverer)
      @@discoverers << discoverer
    end

    def self.find_all
      @@discoverers.flat_map do |discoverer|
        discoverer.new.discover
      end
    end

    private
    def create_project(path)
      ProjectTemplate.new(path)
    end
  end
end
