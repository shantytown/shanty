RSpec.shared_context('with tmp shanty') do
  around do |example|
    FileUtils.touch(File.join(root, 'Shantyconfig'))
    project_paths.each { |project_path| FileUtils.mkdir_p(project_path) }

    Dir.chdir(root) { example.run }

    FileUtils.rm_rf(root)
  end

  # We have to use `realpath` for this as, at least on Mac OS X, the temporary
  # dir path that is returned is actually a symlink. Shanty resolves this
  # internally, so if we want to compare to any of the paths correctly we'll
  # need to resolve it too.
  let(:root) { Pathname.new(Dir.mktmpdir('shanty-test')).realpath }
  let(:project_path) { project_paths.first }
  let(:project_paths) do
    [
      File.join(root, 'one'),
      File.join(root, 'two'),
      File.join(root, 'two', 'three')
    ]
  end
end
