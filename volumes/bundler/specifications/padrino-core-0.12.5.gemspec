# -*- encoding: utf-8 -*-
# stub: padrino-core 0.12.5 ruby lib

Gem::Specification.new do |s|
  s.name = "padrino-core"
  s.version = "0.12.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Padrino Team", "Nathan Esquenazi", "Davide D'Agostino", "Arthur Chiu"]
  s.date = "2015-03-04"
  s.description = "The Padrino core gem required for use of this framework"
  s.email = "padrinorb@gmail.com"
  s.executables = ["padrino"]
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["README.rdoc", "bin/padrino"]
  s.homepage = "http://www.padrinorb.com"
  s.licenses = ["MIT"]
  s.rdoc_options = ["--charset=UTF-8"]
  s.rubyforge_project = "padrino-core"
  s.rubygems_version = "2.4.5"
  s.summary = "The required Padrino core gem"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<padrino-support>, ["= 0.12.5"])
      s.add_runtime_dependency(%q<rack>, ["< 1.6.0"])
      s.add_runtime_dependency(%q<sinatra>, ["~> 1.4.2"])
      s.add_runtime_dependency(%q<http_router>, ["~> 0.11.0"])
      s.add_runtime_dependency(%q<thor>, ["~> 0.18"])
      s.add_runtime_dependency(%q<activesupport>, [">= 3.1"])
      s.add_runtime_dependency(%q<rack-protection>, [">= 1.5.0"])
    else
      s.add_dependency(%q<padrino-support>, ["= 0.12.5"])
      s.add_dependency(%q<rack>, ["< 1.6.0"])
      s.add_dependency(%q<sinatra>, ["~> 1.4.2"])
      s.add_dependency(%q<http_router>, ["~> 0.11.0"])
      s.add_dependency(%q<thor>, ["~> 0.18"])
      s.add_dependency(%q<activesupport>, [">= 3.1"])
      s.add_dependency(%q<rack-protection>, [">= 1.5.0"])
    end
  else
    s.add_dependency(%q<padrino-support>, ["= 0.12.5"])
    s.add_dependency(%q<rack>, ["< 1.6.0"])
    s.add_dependency(%q<sinatra>, ["~> 1.4.2"])
    s.add_dependency(%q<http_router>, ["~> 0.11.0"])
    s.add_dependency(%q<thor>, ["~> 0.18"])
    s.add_dependency(%q<activesupport>, [">= 3.1"])
    s.add_dependency(%q<rack-protection>, [">= 1.5.0"])
  end
end
