Gem::Specification.new do |gem|
  gem.name = 'shanty'
  gem.version = '0.1.0'
  gem.homepage = 'https://github.com/shantytown/shanty'
  gem.license = 'MIT'

  gem.authors = [
    'Chris Jansen',
    'Nathan Kleyn'
  ]
  gem.email = [
    'nathan@nathankleyn.com'
  ]
  gem.summary = 'Pluggable, destributed continous delivery framework.'
  gem.description = gem.summary + ' Works with your existing build, test, CI, deployment, or indeed any tools to provide a cohesive way to do continuous delivery.'

  gem.executables << 'shanty'
  gem.files = Dir['**/*'].select { |d| d =~ %r{^(README|bin/|ext/|lib/)} }

  gem.add_dependency 'algorithms', '~> 0.6.1'
  gem.add_dependency 'commander', '~> 4.2.1'
  gem.add_dependency 'deep_merge', '~> 1.0.1'
  gem.add_dependency 'graph', '~> 2.6.0'
  gem.add_dependency 'hooks', '~> 0.4.0'
  gem.add_dependency 'i18n', '~> 0.6.11'

  gem.add_development_dependency 'pry-byebug', '~> 1.3.3'
  gem.add_development_dependency 'rspec', '~> 3.0.0'
  gem.add_development_dependency 'rubocop', '~> 0.24.1'
  gem.add_development_dependency 'rubocop-rspec', '~> 1.1.0'
  gem.add_development_dependency 'rake', '~> 10.3.2'
  gem.add_development_dependency 'coveralls', '~> 0.7.1'
end
