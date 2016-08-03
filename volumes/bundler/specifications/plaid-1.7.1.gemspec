# -*- encoding: utf-8 -*-
# stub: plaid 1.7.1 ruby lib

Gem::Specification.new do |s|
  s.name = "plaid"
  s.version = "1.7.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Justin Crites"]
  s.date = "2015-12-16"
  s.description = "Ruby gem wrapper for the Plaid API. Read more at the homepage, the wiki, or the plaid documentation."
  s.email = ["crites.justin@gmail.com"]
  s.homepage = "https://github.com/plaid/plaid-ruby"
  s.licenses = ["MIT"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")
  s.rubygems_version = "2.4.5"
  s.summary = "Ruby bindings for Plaid"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, ["~> 1.7"])
      s.add_development_dependency(%q<rake>, ["~> 10.0"])
      s.add_development_dependency(%q<rspec>, ["~> 3.1"])
      s.add_development_dependency(%q<pry>, [">= 0"])
      s.add_development_dependency(%q<pry-stack_explorer>, [">= 0"])
      s.add_development_dependency(%q<webmock>, [">= 0"])
    else
      s.add_dependency(%q<bundler>, ["~> 1.7"])
      s.add_dependency(%q<rake>, ["~> 10.0"])
      s.add_dependency(%q<rspec>, ["~> 3.1"])
      s.add_dependency(%q<pry>, [">= 0"])
      s.add_dependency(%q<pry-stack_explorer>, [">= 0"])
      s.add_dependency(%q<webmock>, [">= 0"])
    end
  else
    s.add_dependency(%q<bundler>, ["~> 1.7"])
    s.add_dependency(%q<rake>, ["~> 10.0"])
    s.add_dependency(%q<rspec>, ["~> 3.1"])
    s.add_dependency(%q<pry>, [">= 0"])
    s.add_dependency(%q<pry-stack_explorer>, [">= 0"])
    s.add_dependency(%q<webmock>, [">= 0"])
  end
end
