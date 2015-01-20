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
  gem.description = "See #{gem.homepage} for more information!"

  gem.executables << 'shanty'
  gem.files = Dir['**/*'].select { |d| d =~ %r{^(README|bin/|ext/|lib/)} }

  gem.add_dependency 'algorithms', '~> 0.6'
  gem.add_dependency 'commander', '~> 4.2'
  gem.add_dependency 'deep_merge', '~> 1.0'
  gem.add_dependency 'i18n', '~> 0.7'

  gem.add_development_dependency 'pry-byebug', '~> 2.0'
  gem.add_development_dependency 'rspec', '~> 3.1'
  gem.add_development_dependency 'rubocop', '~> 0.28'
  gem.add_development_dependency 'rubocop-rspec', '~> 1.2'
  gem.add_development_dependency 'rake', '~> 10.4'
  gem.add_development_dependency 'coveralls', '~> 0.7'
end
