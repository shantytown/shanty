require 'shanty/artifact'

# All classes referenced belong to the shanty project
module Shanty
  RSpec.describe(Artifact) do
    subject { described_class.new('html', 'test', uri) }
    let(:relative_path_artifact) { described_class.new('html', 'test', URI('file:kim/cage.html')) }
    let(:http_artifact) { described_class.new('html', 'test', URI('http://www.nic.com/kim/cage.html')) }
    let(:schemless_artifact) { described_class.new('html', 'test', URI('kim/cage.html')) }

    let(:uri) { URI('file:///nic/kim/cage.html') }

    describe('.new') do
      it('fails if the URI is not an absolute path') do
        expect { relative_path_artifact }.to raise_error('URI is not absolute')
      end

      it('fails if there is no scheme present in the URI') do
        expect { schemless_artifact }.to raise_error('Scheme not present on URI')
      end
    end

    describe('#local?') do
      it('returns false if the file is not a local file') do
        expect(http_artifact.local?).to be(false)
      end

      it('returns true if the file is a local file') do
        expect(subject.local?).to be(true)
      end
    end

    describe('#to_local_path') do
      it('throws an exception if the resource is not local') do
        allow(subject).to receive(:local?).and_return(false)
        expect { subject.to_local_path }.to raise_error('URI is not a local resource')
      end

      it('returns the path if the resource is local') do
        expect(subject.to_local_path).to eql('/nic/kim/cage.html')
      end
    end
  end
end
