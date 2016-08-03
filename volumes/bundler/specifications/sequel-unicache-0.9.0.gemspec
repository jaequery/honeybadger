# -*- encoding: utf-8 -*-
# stub: sequel-unicache 0.9.0 ruby lib

Gem::Specification.new do |s|
  s.name = "sequel-unicache"
  s.version = "0.9.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Bachue Zhou"]
  s.date = "2015-02-01"
  s.description = "Read through caching library inspired by Cache Money, support Sequel 4\n\nRead-Through: Queries by ID or any specified unique key, like `User[params[:id]]` or `User[username: 'bachue@gmail.com']`, will first look in memcache store and then look in the database for the results of that query. If there is a cache miss, it will populate the cache. As objects are created, updated, and deleted, all of the caches are automatically expired.\n"
  s.email = ["bachue.shu@gmail.com"]
  s.homepage = "https://github.com/bachue/sequel-unicache"
  s.licenses = ["GPLv2"]
  s.required_ruby_version = Gem::Requirement.new("~> 2.1")
  s.rubygems_version = "2.4.5"
  s.summary = "Write through and Read through caching library inspired by Cache Money, support Sequel 4"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sequel>, ["~> 4.0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.7"])
      s.add_development_dependency(%q<rake>, ["~> 10.0"])
      s.add_development_dependency(%q<dalli>, [">= 0"])
      s.add_development_dependency(%q<pry>, [">= 0"])
      s.add_development_dependency(%q<pry-doc>, [">= 0"])
      s.add_development_dependency(%q<pry-byebug>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<sqlite3>, [">= 0"])
      s.add_development_dependency(%q<activesupport>, [">= 0"])
    else
      s.add_dependency(%q<sequel>, ["~> 4.0"])
      s.add_dependency(%q<bundler>, ["~> 1.7"])
      s.add_dependency(%q<rake>, ["~> 10.0"])
      s.add_dependency(%q<dalli>, [">= 0"])
      s.add_dependency(%q<pry>, [">= 0"])
      s.add_dependency(%q<pry-doc>, [">= 0"])
      s.add_dependency(%q<pry-byebug>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
      s.add_dependency(%q<activesupport>, [">= 0"])
    end
  else
    s.add_dependency(%q<sequel>, ["~> 4.0"])
    s.add_dependency(%q<bundler>, ["~> 1.7"])
    s.add_dependency(%q<rake>, ["~> 10.0"])
    s.add_dependency(%q<dalli>, [">= 0"])
    s.add_dependency(%q<pry>, [">= 0"])
    s.add_dependency(%q<pry-doc>, [">= 0"])
    s.add_dependency(%q<pry-byebug>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
    s.add_dependency(%q<activesupport>, [">= 0"])
  end
end
