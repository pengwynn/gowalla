# -*- encoding: utf-8 -*-
require File.expand_path('../lib/gowalla/version', __FILE__)

Gem::Specification.new do |s|
  s.name = 'gowalla'
  s.version = Gowalla::VERSION
  s.authors = ["Wynn Netherland", "Eric Hutzelman"]
  s.email = ['wynn.netherland@gmail.com']
  s.summary = %q{Wrapper for the Gowalla API}
  s.description = %q{Ruby wrapper for the Gowalla API}
  s.homepage = 'http://wynnnetherland.com/projects/gowalla/'

  s.add_runtime_dependency 'faraday', '~> 0.6'
  s.add_runtime_dependency 'faraday_middleware', '~> 0.6'
  s.add_runtime_dependency 'hashie', '~> 1.0.0'
  s.add_runtime_dependency 'oauth2', '~> 0.4'

  s.add_development_dependency 'bundler', '~> 1.0'
  s.add_development_dependency 'fakeweb', '~> 1.3'
  s.add_development_dependency 'jnunemaker-matchy', '~> 0.4'
  s.add_development_dependency 'json_pure', '~> 1.5'
  s.add_development_dependency 'rake', '~> 0.8'
  s.add_development_dependency 'shoulda', '~> 2.11'
  s.add_development_dependency 'test-unit', '~> 2.1'

  s.required_rubygems_version = Gem::Requirement.new('>= 1.3.6') if s.respond_to? :required_rubygems_version=
  s.platform = Gem::Platform::RUBY
  s.require_paths = ['lib']
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{|f| File.basename(f)}
end
