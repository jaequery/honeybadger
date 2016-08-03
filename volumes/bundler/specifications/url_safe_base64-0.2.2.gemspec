# -*- encoding: utf-8 -*-
# stub: url_safe_base64 0.2.2 ruby lib

Gem::Specification.new do |s|
  s.name = "url_safe_base64"
  s.version = "0.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Joe Noon"]
  s.date = "2013-10-01"
  s.description = "Converts strings to/from a slightly modified base64 that contains only url-safe characters"
  s.email = ["joenoon@gmail.com"]
  s.homepage = "http://github.com/joenoon/url_safe_base64"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.5"
  s.summary = "Converts strings to/from a slightly modified base64 that contains only url-safe characters"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, ["~> 1.3"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<bundler>, ["~> 1.3"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<bundler>, ["~> 1.3"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
