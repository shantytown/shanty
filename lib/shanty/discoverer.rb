require 'shanty/util'
require 'shanty/project_template'

module Shanty
  # Public: Enables discovery of different types of project
  # utilises inherited class method to find all implementing
  # classes
  class Discoverer
    class << self
      attr_reader :discoverers
    end

    def self.inherited(discoverer)
      Util.logger.debug("Detected project discoverer #{discoverer}")
      @discoverers ||= []
      @discoverers << discoverer
    end

    def discover_all
      self.class.discoverers.flat_map do |discoverer|
        discoverer.new.discover
      end
    end

    private

    def create_project_template(*args)
      ProjectTemplate.new(Dir.pwd, *args).tap { |pt| yield pt }
    end
  end
end
