# -*- encoding: utf-8 -*-
# stub: sequel_secure_password 0.2.12 ruby lib

Gem::Specification.new do |s|
  s.name = "sequel_secure_password"
  s.version = "0.2.12"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Mateusz Lenik"]
  s.date = "2015-03-03"
  s.description = "Plugin adds authentication methods to Sequel models using BCrypt library."
  s.email = ["gems@mlen.pl"]
  s.homepage = "http://github.com/mlen/sequel_secure_password"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.5"
  s.summary = "Plugin adds BCrypt authentication and password hashing to Sequel models. Model using this plugin should have 'password_digest' field.  This plugin was created by extracting has_secure_password strategy from rails."

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<bcrypt>, ["< 4.0", ">= 3.1"])
      s.add_runtime_dependency(%q<sequel>, ["< 5.0", ">= 4.1.0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.14"])
      s.add_development_dependency(%q<rake>, ["~> 10"])
      s.add_development_dependency(%q<rubygems-tasks>, ["~> 0.2"])
      s.add_development_dependency(%q<pry>, [">= 0"])
      s.add_development_dependency(%q<sqlite3>, ["~> 1.3.0"])
    else
      s.add_dependency(%q<bcrypt>, ["< 4.0", ">= 3.1"])
      s.add_dependency(%q<sequel>, ["< 5.0", ">= 4.1.0"])
      s.add_dependency(%q<rspec>, ["~> 2.14"])
      s.add_dependency(%q<rake>, ["~> 10"])
      s.add_dependency(%q<rubygems-tasks>, ["~> 0.2"])
      s.add_dependency(%q<pry>, [">= 0"])
      s.add_dependency(%q<sqlite3>, ["~> 1.3.0"])
    end
  else
    s.add_dependency(%q<bcrypt>, ["< 4.0", ">= 3.1"])
    s.add_dependency(%q<sequel>, ["< 5.0", ">= 4.1.0"])
    s.add_dependency(%q<rspec>, ["~> 2.14"])
    s.add_dependency(%q<rake>, ["~> 10"])
    s.add_dependency(%q<rubygems-tasks>, ["~> 0.2"])
    s.add_dependency(%q<pry>, [">= 0"])
    s.add_dependency(%q<sqlite3>, ["~> 1.3.0"])
  end
end
