# -*- encoding: utf-8 -*-
require File.expand_path("../lib/gowalla/version", __FILE__)

Gem::Specification.new do |s|
  s.name = "gowalla"
  s.version = Gowalla::VERSION
  s.authors = ["Wynn Netherland", "Eric Hutzelman"]
  s.email = ["wynn.netherland@gmail.com"]
  s.summary = %q{Wrapper for the Gowalla API}
  s.description = %q{Ruby wrapper for the Gowalla API}
  s.homepage = "http://wynnnetherland.com/projects/gowalla/"

  s.add_runtime_dependency "faraday", "~> 0.5.1"
  s.add_runtime_dependency "faraday_middleware", "~> 0.1.7"
  s.add_runtime_dependency "hashie", "~> 0.4.0"
  s.add_runtime_dependency "oauth2", "~> 0.1.0"

  s.add_development_dependency "bundler", "~> 1.0"
  s.add_development_dependency "fakeweb", "~> 1.3"
  s.add_development_dependency "jnunemaker-matchy", "~> 0.4"
  s.add_development_dependency "json_pure", "~> 1.4"
  s.add_development_dependency "rake", "~> 0.8"
  s.add_development_dependency "shoulda", "~> 2.11"

  s.required_rubygems_version = ">= 1.3.6"
  s.platform = Gem::Platform::RUBY
  s.require_path  = 'lib'
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
end
