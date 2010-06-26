require 'bundler'
require 'bundler/version'
require 'lib/gowalla'

Gem::Specification.new do |s|
  s.name = %q{gowalla}
  s.version = Gowalla::VERSION
  s.platform    = Gem::Platform::RUBY
  s.required_rubygems_version = ">= 1.3.6"
  s.authors = ["Wynn Netherland"]
  s.date = %q{2010-06-26}
  s.description = %q{Ruby wrapper for the Gowalla API}
  s.email = %q{wynn.netherland@gmail.com}
  s.files = Dir.glob("{lib}/**/*")
  s.homepage = %q{http://wynnnetherland.com/projects/gowalla/}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Wrapper for the Gowalla API}
  s.test_files = [
    "test/helper.rb",
    "test/gowalla_test.rb"
  ]

  s.add_bundler_dependencies
end
