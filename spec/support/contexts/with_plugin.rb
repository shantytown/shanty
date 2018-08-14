require 'active_support/core_ext/hash/indifferent_access'
require_relative 'with_tmp_shanty'

RSpec.shared_context('with plugin') do
  include_context('with tmp shanty')
  subject { described_class.new(project, env) }

  before do
    allow(env).to receive(:file_tree).and_return(file_tree)
    allow(env).to receive(:projects).and_return({})
    allow(env).to receive(:root).and_return(root)
    allow(env).to receive(:config).and_return(
      HashWithIndifferentAccess.new { |h, k| h[k] = HashWithIndifferentAccess.new }
    )

    allow(file_tree).to receive(:glob).and_return([])
  end

  let(:project) { double('project') }
  let(:env) { double('env') }
  let(:file_tree) { double('file tree') }
end
