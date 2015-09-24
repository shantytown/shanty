$LOAD_PATH.unshift(File.join(__dir__, 'lib'))
require 'shanty/info'

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

  gem.add_dependency 'acts_as_graph_vertex', '~>1.0'
  gem.add_dependency 'bundler', '~>1.10'
  gem.add_dependency 'algorithms', '~>0.6'
  gem.add_dependency 'attr_combined_accessor', '~>1.0'
  gem.add_dependency 'call_me_ruby', '~>1.1'
  gem.add_dependency 'commander', '~>4.3'
  gem.add_dependency 'gitignore_rb', '~>0.2.2'
  gem.add_dependency 'i18n', '~>0.7'
  gem.add_dependency 'shenanigans', '~>1.0'

  gem.add_development_dependency 'coveralls', '~>0.8'
  gem.add_development_dependency 'cucumber', '~>2.1'
  gem.add_development_dependency 'filewatcher', '~>0.5'
  gem.add_development_dependency 'pry-byebug', '~> 3.1'
  gem.add_development_dependency 'rspec', '~> 3.2'
  gem.add_development_dependency 'rubocop', '~> 0.31'
  gem.add_development_dependency 'rubocop-rspec', '~> 1.3'
  gem.add_development_dependency 'ruby-prof', '~>0.15'
end
