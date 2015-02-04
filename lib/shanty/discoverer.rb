require 'shanty/project_template'

module Shanty
  # Public: Enables discovery of different types of project
  # utilises inherited class method to find all implementing
  # classes
  class Discoverer
    attr_reader :env

    def initialize(env)
      @env = env
    end

    def self.inherited(discoverer)
      discoverers << discoverer
    end

    def self.discoverers
      @discoverers ||= []
    end

    def discover_all
      self.class.discoverers
        .lazy
        .flat_map { |discoverer| discoverer.new(env).discover.each(&:setup!) }
        .sort_by(&:priority)
        .reverse
        .uniq(&:path)
        .to_a
    end

    private

    def create_project_template(*args)
      ProjectTemplate.new(env, *args).tap { |pt| yield pt }
    end
  end
end
