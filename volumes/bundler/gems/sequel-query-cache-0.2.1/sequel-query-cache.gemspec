require './lib/sequel-query-cache/version'

Gem::Specification.new do |s|
  s.name          = 'sequel-query-cache'
  s.version       = Sequel::Plugins::QueryCache::VERSION
  s.license       = 'MIT'

  s.authors       = ['Joshua Hansen']
  s.email         = ['joshua@amicus-tech.com']
  s.homepage      = 'https://github.com/binarypaladin/sequel-query-cache'

  s.summary       = 'A plugin for Sequel that allows dataset results to be cached in Memcached or Redis.'
  s.description   = s.summary

  s.files = Dir.glob('lib/**/*') + [
     'Gemfile',
     'History.md',
     'LICENSE',
     'Rakefile',
     'README.md',
     'sequel-query-cache.gemspec',
  ]

  s.test_files    = Dir.glob('spec/**/*')
  s.require_paths = ['lib']

  s.add_dependency 'sequel', ['>= 3.42', '< 5.0']
end
