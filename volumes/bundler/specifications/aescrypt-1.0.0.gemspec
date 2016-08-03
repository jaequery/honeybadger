# -*- encoding: utf-8 -*-
# stub: aescrypt 1.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "aescrypt"
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Gurpartap Singh"]
  s.date = "2012-07-31"
  s.description = "Simple AES encryption / decryption for Ruby"
  s.email = ["contact@gurpartap.com"]
  s.homepage = "http://github.com/Gurpartap/aescrypt"
  s.rubygems_version = "2.4.5"
  s.summary = "AESCrypt is a simple to use, opinionated AES encryption / decryption Ruby gem that just works."

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
