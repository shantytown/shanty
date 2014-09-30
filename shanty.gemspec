Gem::Specification.new do |gem|
  gem.name = 'shanty'
  gem.version = '0.0.1'

  gem.authors = [
    'Chris Jansen',
    'Nathan Kleyn'
  ]
  gem.summary = 'Pluggable build and CI tool'
  gem.description = gem.summary

  gem.executables << 'shanty'
  gem.files = Dir['**/*'].select { |d| d =~ %r{^(README|bin/|ext/|lib/)} }

  gem.add_dependency 'thor', '~> 0.18.1'
  gem.add_dependency 'algorithms', '~> 0.6.1'
  gem.add_dependency 'graph', '~> 2.6.0'
  gem.add_dependency 'deep_merge', '~> 1.0.1'

  gem.add_development_dependency 'pry-byebug', '~> 1.3.3'
  gem.add_development_dependency 'rspec', '~> 3.0.0'
  gem.add_development_dependency 'rubocop', '~> 0.24.1'
  gem.add_development_dependency 'rubocop-rspec', '~> 1.1.0'
  gem.add_development_dependency 'rake', '~> 10.3.2'
  gem.add_development_dependency 'coveralls', '~> 0.7.1'
end
