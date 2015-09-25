# Something, something, darkside.
module Shanty
  RSpec::Matchers.define(:subscribe_to) do |event|
    match do |actual|
      expect(actual.instance_variable_get(:@class_callbacks)).to include(event => @callbacks)
    end

    chain(:with) do |*callbacks|
      @callbacks = callbacks
    end
  end
end
