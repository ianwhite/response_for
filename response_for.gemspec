# -*- encoding: utf-8 -*-

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require 'response_for/version'
version = ResponseFor::VERSION

Gem::Specification.new do |s|
  s.name        = "response_for_rails"
  s.version     = version
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ian White"]
  s.email       = "ian.w.white@gmail.com"
  s.homepage    = "http://github.com/ianwhite/response_for"
  s.summary     = "response_for-#{version}"
  s.description = "response_for allows you to decorate the respond_to block of actions on subclassed controllers."

  s.rubygems_version   = "1.3.7"

  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {spec}/*`.split("\n")
  s.extra_rdoc_files = [ "README.rdoc", "MIT-LICENSE", 'CHANGELOG' ]
  s.rdoc_options     = ["--charset=UTF-8"]
  s.require_path     = "lib"

  s.add_runtime_dependency "rails", '>= 3.0.0'
  s.add_development_dependency "rspec", '>= 2.5.0'
  s.add_development_dependency "rspec-rails", '>= 2.5.0'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency "rspec-rails", '>= 2.5.0'
end