require 'active_support/core_ext/hash/indifferent_access'

RSpec.describe(Shanty::ConfigMixin) do
  subject { test_config_class.new }
  let(:test_config_class) { Class.new.tap { |klass| klass.include(described_class) } }

  describe('#config') do
    it('returns a hash with indifferent access') do
      expect(subject.config).to be_a(HashWithIndifferentAccess)
    end

    it('creates a new hash when key does not exist') do
      expect(subject.config[:nic]).to be_a(HashWithIndifferentAccess)
      expect(subject.config[:nic]).to be_empty
    end

    it('allows setting of plugin config') do
      subject.config[:nic][:kim] = 'cage'

      expect(subject.config[:nic]).to eql('kim' => 'cage')
      expect(subject.config[:nic][:kim]).to eql('cage')
    end
  end
end
