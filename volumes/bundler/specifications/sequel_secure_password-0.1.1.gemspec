# -*- encoding: utf-8 -*-
# stub: sequel_secure_password 0.1.1 ruby lib

Gem::Specification.new do |s|
  s.name = "sequel_secure_password"
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Mateusz Lenik"]
  s.date = "2013-06-13"
  s.description = "Plugin adds authentication methods to Sequel models using BCrypt library."
  s.email = ["mt.lenik@gmail.com"]
  s.homepage = "http://github.com/mlen/sequel_secure_password"
  s.rubygems_version = "2.5.0"
  s.summary = "Plugin adds BCrypt authentication and password hashing to Sequel models. Model using this plugin should have 'password_digest' field.  This plugin was created by extracting has_secure_password strategy from rails."

  s.installed_by_version = "2.5.0" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<bcrypt-ruby>, ["~> 3.0.0"])
      s.add_runtime_dependency(%q<sequel>, ["~> 3.48.0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.13.0"])
      s.add_development_dependency(%q<rake>, ["~> 10.0.0"])
      s.add_development_dependency(%q<sqlite3>, ["~> 1.3.0"])
    else
      s.add_dependency(%q<bcrypt-ruby>, ["~> 3.0.0"])
      s.add_dependency(%q<sequel>, ["~> 3.48.0"])
      s.add_dependency(%q<rspec>, ["~> 2.13.0"])
      s.add_dependency(%q<rake>, ["~> 10.0.0"])
      s.add_dependency(%q<sqlite3>, ["~> 1.3.0"])
    end
  else
    s.add_dependency(%q<bcrypt-ruby>, ["~> 3.0.0"])
    s.add_dependency(%q<sequel>, ["~> 3.48.0"])
    s.add_dependency(%q<rspec>, ["~> 2.13.0"])
    s.add_dependency(%q<rake>, ["~> 10.0.0"])
    s.add_dependency(%q<sqlite3>, ["~> 1.3.0"])
  end
end
