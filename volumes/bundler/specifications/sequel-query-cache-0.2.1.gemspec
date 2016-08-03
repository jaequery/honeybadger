# -*- encoding: utf-8 -*-
# stub: sequel-query-cache 0.2.1 ruby lib

Gem::Specification.new do |s|
  s.name = "sequel-query-cache"
  s.version = "0.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Joshua Hansen"]
  s.date = "2015-01-14"
  s.description = "A plugin for Sequel that allows dataset results to be cached in Memcached or Redis."
  s.email = ["joshua@amicus-tech.com"]
  s.homepage = "https://github.com/binarypaladin/sequel-query-cache"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.5"
  s.summary = "A plugin for Sequel that allows dataset results to be cached in Memcached or Redis."

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sequel>, ["< 5.0", ">= 3.42"])
    else
      s.add_dependency(%q<sequel>, ["< 5.0", ">= 3.42"])
    end
  else
    s.add_dependency(%q<sequel>, ["< 5.0", ">= 3.42"])
  end
end
