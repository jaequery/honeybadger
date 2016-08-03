# -*- encoding: utf-8 -*-
# stub: mailjet 1.3.8 ruby lib

Gem::Specification.new do |s|
  s.name = "mailjet"
  s.version = "1.3.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Tyler Nappy", "Jean-Baptiste Escoyez", "Aur\u{e9}lien AMILIN", "Benoit B\u{e9}n\u{e9}zech"]
  s.date = "2016-03-22"
  s.description = "Ruby wrapper for Mailjet's v3 API"
  s.email = ["tyler@mailjet.com", "devrel-team@mailjet.com", "jbescoyez@gmail.com"]
  s.homepage = "http://www.mailjet.com"
  s.rubygems_version = "2.4.5"
  s.summary = "Mailjet a powerful all-in-one email service provider clients can use to get maximum insight and deliverability results from both their marketing and transactional emails. Our analytics tools and intelligent APIs give senders the best understanding of how to maximize benefits for each individual contact, with each email sent."

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 3.1.0"])
      s.add_runtime_dependency(%q<rack>, [">= 1.4.0"])
      s.add_runtime_dependency(%q<rest-client>, [">= 0"])
      s.add_development_dependency(%q<actionmailer>, [">= 3.0.9"])
      s.add_development_dependency(%q<minitest>, [">= 0"])
      s.add_development_dependency(%q<minitest-matchers>, [">= 0"])
      s.add_development_dependency(%q<minitest-spec-context>, [">= 0"])
      s.add_development_dependency(%q<turn>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<json>, [">= 0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
      s.add_development_dependency(%q<webmock>, [">= 0"])
      s.add_development_dependency(%q<vcr>, [">= 0"])
      s.add_development_dependency(%q<guard>, [">= 0"])
      s.add_development_dependency(%q<guard-minitest>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<rspec-expectations>, [">= 0"])
      s.add_development_dependency(%q<dotenv>, [">= 0"])
    else
      s.add_dependency(%q<activesupport>, [">= 3.1.0"])
      s.add_dependency(%q<rack>, [">= 1.4.0"])
      s.add_dependency(%q<rest-client>, [">= 0"])
      s.add_dependency(%q<actionmailer>, [">= 3.0.9"])
      s.add_dependency(%q<minitest>, [">= 0"])
      s.add_dependency(%q<minitest-matchers>, [">= 0"])
      s.add_dependency(%q<minitest-spec-context>, [">= 0"])
      s.add_dependency(%q<turn>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0"])
      s.add_dependency(%q<webmock>, [">= 0"])
      s.add_dependency(%q<vcr>, [">= 0"])
      s.add_dependency(%q<guard>, [">= 0"])
      s.add_dependency(%q<guard-minitest>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<rspec-expectations>, [">= 0"])
      s.add_dependency(%q<dotenv>, [">= 0"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 3.1.0"])
    s.add_dependency(%q<rack>, [">= 1.4.0"])
    s.add_dependency(%q<rest-client>, [">= 0"])
    s.add_dependency(%q<actionmailer>, [">= 3.0.9"])
    s.add_dependency(%q<minitest>, [">= 0"])
    s.add_dependency(%q<minitest-matchers>, [">= 0"])
    s.add_dependency(%q<minitest-spec-context>, [">= 0"])
    s.add_dependency(%q<turn>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0"])
    s.add_dependency(%q<webmock>, [">= 0"])
    s.add_dependency(%q<vcr>, [">= 0"])
    s.add_dependency(%q<guard>, [">= 0"])
    s.add_dependency(%q<guard-minitest>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<rspec-expectations>, [">= 0"])
    s.add_dependency(%q<dotenv>, [">= 0"])
  end
end
