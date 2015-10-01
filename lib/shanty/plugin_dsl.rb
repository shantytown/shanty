module Shanty
  # Small mixin providing the DSL style class methods that plugin authors will rely on. This module is expected to be
  # mixed into a Plugin class.
  module PluginDsl
    def provides_projects(*syms)
      project_providers.concat(syms.map(&:to_sym))
    end

    def provides_projects_containing(*globs)
      project_globs.concat(globs.map(&:to_s))
    end

    def provides_tags(*args)
      tags.concat(args.map(&:to_sym))
    end
  end
end
