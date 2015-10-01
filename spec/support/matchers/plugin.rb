# Something, something, darkside.
module Shanty
  RSpec::Matchers.define(:provide_tags) do |*tags|
    match do |actual|
      expect(actual.tags).to include(*tags)
    end
  end

  RSpec::Matchers.define(:provide_projects) do |*syms|
    match do |actual|
      expect(actual.instance_variable_get(:@project_providers)).to include(*syms)
    end
  end

  RSpec::Matchers.define(:provide_projects_containing) do |*globs|
    match do |actual|
      expect(actual.instance_variable_get(:@project_globs)).to include(*globs)
    end
  end
end
