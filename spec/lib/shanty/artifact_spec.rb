require 'shanty/artifact'

# All classes referenced belong to the shanty project
module Shanty
  RSpec.describe(Artifact) do
    subject { Artifact.new('html', 'test', uri) }

    describe('#localfile') do
      let(:uri) { URI('file:///nic/kim/cage.html') }

      it('works with a local file') do
        expect(subject.local?).to be(true)
        expect(subject.to_local_path).to eql('/nic/kim/cage.html')
      end
    end

    describe('#noscheme') do
      let(:uri) { URI('kim/cage.html') }
      it('fails if there is no scheme present in the URI') do
        expect { subject }.to raise_error('Scheme not present on URI')
      end
    end

    describe('#notabsolute') do
      let(:uri) { URI('file:kim/cage.html') }
      it('fails if the URI is not an absolute path') do
        expect { subject }.to raise_error('URI is not absolute')
      end
    end

    describe('#remotefile') do
      let(:uri) { URI('http://www.nic.com/kim/cage.html') }

      it('fails when converting to a local path if the resource is not local') do
        expect(subject.local?).to be(false)
        expect { subject.to_local_path }.to raise_error('URI is not a local resource')
      end
    end
  end
end
