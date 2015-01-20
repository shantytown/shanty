require 'shanty/mutator'
require 'shanty/plugins/bundler'

module Shanty
  # Bundler mutator
  class BundlerMutator < Mutator
    def mutate(graph)
      graph.each do |project|
        BundlerPlugin.add_to_project(project) if File.exist?(File.join(project.path, 'Gemfile'))
      end
    end
  end
end
