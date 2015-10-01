require 'spec_helper'
require 'shanty/logger'

RSpec.describe(Shanty::Logger) do
  describe('#logger') do
    it('returns a logger object') do
      expect(subject.logger).to be_a(Logger)
    end
  end
end
