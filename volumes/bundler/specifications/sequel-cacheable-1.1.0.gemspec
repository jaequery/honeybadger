# -*- encoding: utf-8 -*-
# stub: sequel-cacheable 1.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "sequel-cacheable"
  s.version = "1.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Sho Kusano"]
  s.date = "2013-06-27"
  s.description = "This plug-in caching mechanism to implement the Model of the Sequel"
  s.email = ["rosylilly@aduca.org"]
  s.homepage = "https://github.com/rosylilly/sequel-cacheable"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.5.0"
  s.summary = "This plug-in caching mechanism to implement the Model of the Sequel"

  s.installed_by_version = "2.5.0" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sequel>, ["~> 3.42"])
      s.add_runtime_dependency(%q<msgpack>, ["~> 0.5.1"])
    else
      s.add_dependency(%q<sequel>, ["~> 3.42"])
      s.add_dependency(%q<msgpack>, ["~> 0.5.1"])
    end
  else
    s.add_dependency(%q<sequel>, ["~> 3.42"])
    s.add_dependency(%q<msgpack>, ["~> 0.5.1"])
  end
end
