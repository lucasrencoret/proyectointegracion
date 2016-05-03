# -*- encoding: utf-8 -*-
# stub: rf-rest-open-uri 1.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "rf-rest-open-uri"
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Leonard Richardson", "Rick Fletcher"]
  s.date = "2014-03-21"
  s.description = "A fork of rest-open-uri, updated for ruby 1.9.3+"
  s.homepage = "https://github.com/rfletcher/rf-rest-open-uri"
  s.licenses = ["MIT"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")
  s.rubygems_version = "2.5.1"
  s.summary = "rf-rest-open-uri applies the original rest-open-uri patch to ruby 1.9.3's open-uri. The version provided with rest-open-uri 1.0.0 is old, and missing newer open-uri features like :ssl_verify_mode."

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

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
