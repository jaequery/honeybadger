# -*- encoding: utf-8 -*-
# stub: passenger 5.0.21 ruby src/ruby_supportlib
# stub: src/helper-scripts/download_binaries/extconf.rb

Gem::Specification.new do |s|
  s.name = "passenger"
  s.version = "5.0.21"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["src/ruby_supportlib"]
  s.authors = ["Phusion - http://www.phusion.nl/"]
  s.date = "2015-10-22"
  s.description = "A modern web server and application server for Ruby, Python and Node.js, optimized for performance, low memory usage and ease of use."
  s.email = "software-signing@phusion.nl"
  s.executables = ["passenger", "passenger-install-apache2-module", "passenger-install-nginx-module", "passenger-config", "passenger-status", "passenger-memory-stats"]
  s.extensions = ["src/helper-scripts/download_binaries/extconf.rb"]
  s.files = ["bin/passenger", "bin/passenger-config", "bin/passenger-install-apache2-module", "bin/passenger-install-nginx-module", "bin/passenger-memory-stats", "bin/passenger-status", "src/helper-scripts/download_binaries/extconf.rb"]
  s.homepage = "https://www.phusionpassenger.com/"
  s.rubyforge_project = "passenger"
  s.rubygems_version = "2.4.5"
  s.summary = "A fast and robust web server and application server for Ruby, Python and Node.js"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rake>, [">= 0.8.1"])
      s.add_runtime_dependency(%q<rack>, [">= 0"])
    else
      s.add_dependency(%q<rake>, [">= 0.8.1"])
      s.add_dependency(%q<rack>, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0.8.1"])
    s.add_dependency(%q<rack>, [">= 0"])
  end
end
