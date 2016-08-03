# -*- encoding: utf-8 -*-
# stub: sinatra-contrib 1.4.7 ruby lib

Gem::Specification.new do |s|
  s.name = "sinatra-contrib"
  s.version = "1.4.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Konstantin Haase", "Zachary Scott", "Gabriel Andretta", "Trevor Bramble", "Katrina Owen", "Ashley Williams", "Nicolas Sanguinetti", "Hrvoje \u{160}imi\u{107}", "Masahiro Fujiwara", "Rafael Magana", "Vipul A M", "ashley williams", "Jack Chu", "Sumeet Singh", "Ilya Shindyapin", "lest", "Jake Worth", "Kashyap", "Matt Lyon", "Matthew Conway", "Meck", "Michi Huber", "Nic Benders", "Patricio Mac Adden", "Reed Lipman", "Samy Dindane", "Sergey Nartimov", "Thibaut Sacreste", "Uchio KONDO", "Will Bailey", "mono", "Adrian Paca\u{142}a", "undr", "Aish", "Alexey Chernenkov", "Andrew Crump", "Anton Davydov", "Bo Jeanes", "David Asabina", "Eliot Shepard", "Eric Marden", "Gray Manley", "Guillaume Bouteille", "Jamie Hodge", "Julie Ng", "Koichi Sasada", "Kyle Lacy", "Lars Vonk", "Martin Frost", "Mathieu Allaire"]
  s.date = "2016-04-11"
  s.description = "Collection of useful Sinatra extensions"
  s.email = ["konstantin.mailinglists@googlemail.com", "ohhgabriel@gmail.com", "inbox@trevorbramble.com", "e@zzak.io", "zachary@zacharyscott.net", "katrina.owen@gmail.com", "ashley@bocoup.com", "contacto@nicolassanguinetti.info", "shime.ferovac@gmail.com", "raf.magana@gmail.com", "m-fujiwara@axsh.net", "vipulnsward@gmail.com", "konstantin.haase@gmail.com", "jack@jackchu.com", "ashley666ashley@gmail.com", "ilya@shindyapin.com", "just.lest@gmail.com", "kashyap.kmbc@gmail.com", "ortuna@gmail.com", "tbramble@chef.io", "jworth@prevailhs.com", "mail@zzak.io", "nic@newrelic.com", "patriciomacadden@gmail.com", "rmlipman@gmail.com", "samy@dindane.com", "just.lest@gmail.com", "thibaut.sacreste@gmail.com", "udzura@udzura.jp", "will.bailey@gmail.com", "mono@mono0x.net", "altpacala@gmail.com", "undr@yandex.ru", "aisha.fenton@visfleet.com", "laise@pisem.net", "andrew.crump@ieee.org", "antondavydov.o@gmail.com", "me@bjeanes.com", "david@supr.nu", "eshepard@slower.net", "eric.marden@gmail.com", "g.manley@tukaiz.com", "duffman@via.ecp.fr", "jamiehodge@me.com", "uxjulie@gmail.com", "ko1@atdot.net", "kylewlacy@me.com", "lars.vonk@gmail.com", "blame@kth.se", "mathieuallaire@gmail.com", "matt@flowerpowered.com", "himself@mattonrails.com", "yesmeck@gmail.com", "michi.huber@gmail.com"]
  s.homepage = "http://github.com/sinatra/sinatra-contrib"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.5.0"
  s.summary = "Collection of useful Sinatra extensions"

  s.installed_by_version = "2.5.0" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sinatra>, ["~> 1.4.0"])
      s.add_runtime_dependency(%q<backports>, [">= 2.0"])
      s.add_runtime_dependency(%q<tilt>, ["< 3", ">= 1.3"])
      s.add_runtime_dependency(%q<rack-test>, [">= 0"])
      s.add_runtime_dependency(%q<rack-protection>, [">= 0"])
      s.add_runtime_dependency(%q<multi_json>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.3"])
      s.add_development_dependency(%q<haml>, [">= 0"])
      s.add_development_dependency(%q<erubis>, [">= 0"])
      s.add_development_dependency(%q<slim>, [">= 0"])
      s.add_development_dependency(%q<less>, [">= 0"])
      s.add_development_dependency(%q<sass>, [">= 0"])
      s.add_development_dependency(%q<builder>, [">= 0"])
      s.add_development_dependency(%q<liquid>, [">= 0"])
      s.add_development_dependency(%q<redcarpet>, [">= 0"])
      s.add_development_dependency(%q<RedCloth>, [">= 0"])
      s.add_development_dependency(%q<asciidoctor>, [">= 0"])
      s.add_development_dependency(%q<radius>, [">= 0"])
      s.add_development_dependency(%q<coffee-script>, [">= 0"])
      s.add_development_dependency(%q<nokogiri>, [">= 0"])
      s.add_development_dependency(%q<creole>, [">= 0"])
      s.add_development_dependency(%q<wikicloth>, [">= 0"])
      s.add_development_dependency(%q<markaby>, [">= 0"])
      s.add_development_dependency(%q<rake>, ["< 11"])
    else
      s.add_dependency(%q<sinatra>, ["~> 1.4.0"])
      s.add_dependency(%q<backports>, [">= 2.0"])
      s.add_dependency(%q<tilt>, ["< 3", ">= 1.3"])
      s.add_dependency(%q<rack-test>, [">= 0"])
      s.add_dependency(%q<rack-protection>, [">= 0"])
      s.add_dependency(%q<multi_json>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 2.3"])
      s.add_dependency(%q<haml>, [">= 0"])
      s.add_dependency(%q<erubis>, [">= 0"])
      s.add_dependency(%q<slim>, [">= 0"])
      s.add_dependency(%q<less>, [">= 0"])
      s.add_dependency(%q<sass>, [">= 0"])
      s.add_dependency(%q<builder>, [">= 0"])
      s.add_dependency(%q<liquid>, [">= 0"])
      s.add_dependency(%q<redcarpet>, [">= 0"])
      s.add_dependency(%q<RedCloth>, [">= 0"])
      s.add_dependency(%q<asciidoctor>, [">= 0"])
      s.add_dependency(%q<radius>, [">= 0"])
      s.add_dependency(%q<coffee-script>, [">= 0"])
      s.add_dependency(%q<nokogiri>, [">= 0"])
      s.add_dependency(%q<creole>, [">= 0"])
      s.add_dependency(%q<wikicloth>, [">= 0"])
      s.add_dependency(%q<markaby>, [">= 0"])
      s.add_dependency(%q<rake>, ["< 11"])
    end
  else
    s.add_dependency(%q<sinatra>, ["~> 1.4.0"])
    s.add_dependency(%q<backports>, [">= 2.0"])
    s.add_dependency(%q<tilt>, ["< 3", ">= 1.3"])
    s.add_dependency(%q<rack-test>, [">= 0"])
    s.add_dependency(%q<rack-protection>, [">= 0"])
    s.add_dependency(%q<multi_json>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 2.3"])
    s.add_dependency(%q<haml>, [">= 0"])
    s.add_dependency(%q<erubis>, [">= 0"])
    s.add_dependency(%q<slim>, [">= 0"])
    s.add_dependency(%q<less>, [">= 0"])
    s.add_dependency(%q<sass>, [">= 0"])
    s.add_dependency(%q<builder>, [">= 0"])
    s.add_dependency(%q<liquid>, [">= 0"])
    s.add_dependency(%q<redcarpet>, [">= 0"])
    s.add_dependency(%q<RedCloth>, [">= 0"])
    s.add_dependency(%q<asciidoctor>, [">= 0"])
    s.add_dependency(%q<radius>, [">= 0"])
    s.add_dependency(%q<coffee-script>, [">= 0"])
    s.add_dependency(%q<nokogiri>, [">= 0"])
    s.add_dependency(%q<creole>, [">= 0"])
    s.add_dependency(%q<wikicloth>, [">= 0"])
    s.add_dependency(%q<markaby>, [">= 0"])
    s.add_dependency(%q<rake>, ["< 11"])
  end
end
