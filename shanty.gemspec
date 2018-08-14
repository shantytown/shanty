$LOAD_PATH.unshift(File.join(__dir__, 'lib'))
require 'shanty/info'

# rubocop:disable Metrics/BlockLength
Gem::Specification.new do |gem|
  gem.name = 'shanty'
  gem.version = Shanty::Info::VERSION
  gem.homepage = 'https://github.com/shantytown/shanty'
  gem.license = 'MIT'

  gem.authors = [
    'Chris Jansen',
    'Nathan Kleyn'
  ]
  gem.email = [
    'nathan@nathankleyn.com'
  ]
  gem.summary = Shanty::Info::DESCRIPTION
  gem.description = "See #{gem.homepage} for more information!"

  gem.executables << 'shanty'
  gem.files = Dir['**/*'].select { |d| d =~ %r{^(README|bin/|ext/|lib/)} }

  gem.add_dependency 'activesupport', '~>5.2.0'
  gem.add_dependency 'acts_as_graph_vertex', '~>1.0'
  gem.add_dependency 'algorithms', '~>0.6.1'
  gem.add_dependency 'bundler', '~>1.16.3'
  gem.add_dependency 'call_me_ruby', '~>1.1'
  gem.add_dependency 'commander', '~>4.4.6'
  gem.add_dependency 'erubis', '~>2.7.0'
  gem.add_dependency 'gitignore_rb', '~>0.2.4'
  gem.add_dependency 'i18n', '~>1.0.1'
  gem.add_dependency 'terminal-table', '~>1.8.0'

  gem.add_development_dependency 'coveralls', '~>0.8'
  gem.add_development_dependency 'cucumber', '~>3.1'
  gem.add_development_dependency 'filewatcher', '~>1.0'
  gem.add_development_dependency 'pry-byebug', '~>3.6'
  gem.add_development_dependency 'rspec', '~>3.8'
  gem.add_development_dependency 'rubocop', '~>0.58'
  gem.add_development_dependency 'rubocop-rspec', '~>1.27'
  gem.add_development_dependency 'ruby-prof', '~>0.17'
end
# rubocop:enable Metrics/BlockLength
