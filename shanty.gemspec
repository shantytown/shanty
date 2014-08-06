$:.unshift File.expand_path('../lib', __FILE__)
require 'shanty'

Gem::Specification.new do |gem|
  gem.name        = 'shanty'
  gem.version     = Shanty::VERSION

  gem.author      = 'Chris Jansen & Nathan Kleyn'
  gem.email       = ''
  gem.summary     = 'Pluggable build and CI tool'
  gem.description = gem.summary
  gem.executables = 'shanty'

  gem.files = Dir['**/*'].select { |d| d =~ %r{^(README|bin/|ext/|lib/)} }

  gem.add_dependency 'thor',       '~> 0.18.1'
  gem.add_dependency 'algorithms', '~> 0.6.1'
  gem.add_dependency 'graph',      '~> 2.6.0'
end
