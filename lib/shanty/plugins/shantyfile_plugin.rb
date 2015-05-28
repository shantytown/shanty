require 'shanty/plugin'

module Shanty
  # Public: Plugin for finding all directories marked with a Shantyfile.
  module ShantyfilePlugin
    extend Plugin

    wants_projects_matching '**/Shantyfile'
  end
end
