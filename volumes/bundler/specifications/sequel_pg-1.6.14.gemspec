# -*- encoding: utf-8 -*-
# stub: sequel_pg 1.6.14 ruby lib
# stub: ext/sequel_pg/extconf.rb

Gem::Specification.new do |s|
  s.name = "sequel_pg"
  s.version = "1.6.14"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Jeremy Evans"]
  s.date = "2016-01-19"
  s.description = "sequel_pg overwrites the inner loop of the Sequel postgres\nadapter row fetching code with a C version.  The C version\nis significantly faster (2-6x) than the pure ruby version\nthat Sequel uses by default.\n\nsequel_pg also offers optimized versions of some dataset\nmethods, as well as adds support for using PostgreSQL\nstreaming.\n"
  s.email = "code@jeremyevans.net"
  s.extensions = ["ext/sequel_pg/extconf.rb"]
  s.extra_rdoc_files = ["README.rdoc", "CHANGELOG", "MIT-LICENSE"]
  s.files = ["CHANGELOG", "MIT-LICENSE", "README.rdoc", "ext/sequel_pg/extconf.rb"]
  s.homepage = "http://github.com/jeremyevans/sequel_pg"
  s.licenses = ["MIT"]
  s.rdoc_options = ["--quiet", "--line-numbers", "--inline-source", "--title", "sequel_pg: Faster SELECTs when using Sequel with pg", "--main", "README.rdoc"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.7")
  s.rubygems_version = "2.4.5"
  s.summary = "Faster SELECTs when using Sequel with pg"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<pg>, [">= 0.8.0"])
      s.add_runtime_dependency(%q<sequel>, [">= 3.39.0"])
    else
      s.add_dependency(%q<pg>, [">= 0.8.0"])
      s.add_dependency(%q<sequel>, [">= 3.39.0"])
    end
  else
    s.add_dependency(%q<pg>, [">= 0.8.0"])
    s.add_dependency(%q<sequel>, [">= 3.39.0"])
  end
end
