require_relative 'workspace'

RSpec.shared_context('plugin') do
  include_context('workspace')
  subject { described_class.new(project, env) }

  before do
    allow(env).to receive(:file_tree).and_return(file_tree)
    allow(env).to receive(:projects).and_return({})
    allow(env).to receive(:root).and_return(root)

    allow(file_tree).to receive(:glob).and_return([])
  end

  let(:project) { double('project') }
  let(:env) { double('env') }
  let(:file_tree) { double('file tree') }
end
