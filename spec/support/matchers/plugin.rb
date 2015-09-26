# Something, something, darkside.
module Shanty
  RSpec::Matchers.define(:add_tags) do |*tags|
    match do |actual|
      expect(actual.instance_variable_get(:@tags)).to include(*tags)
    end
  end

  RSpec::Matchers.define(:define_projects) do
    match do |actual|
      expect(actual.instance_variable_get(:@project_matchers)).to include(*(@matchers || []))
    end

    chain :with do |*matchers|
      @matchers = matchers
    end
  end
end
