# -*- encoding: utf-8 -*-
# stub: jmespath 1.2.4 ruby lib

Gem::Specification.new do |s|
  s.name = "jmespath"
  s.version = "1.2.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Trevor Rowe"]
  s.date = "2016-04-06"
  s.description = "Implements JMESPath for Ruby"
  s.email = "trevorrowe@gmail.com"
  s.homepage = "http://github.com/trevorrowe/jmespath.rb"
  s.licenses = ["Apache 2.0"]
  s.rubygems_version = "2.4.5"
  s.summary = "JMESPath - Ruby Edition"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json_pure>, [">= 1.8.1"])
    else
      s.add_dependency(%q<json_pure>, [">= 1.8.1"])
    end
  else
    s.add_dependency(%q<json_pure>, [">= 1.8.1"])
  end
end
