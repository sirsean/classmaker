$:.push File.expand_path("../lib", __FILE__)
require "classmaker/version"

spec = Gem::Specification.new do |s|
  s.name = 'classmaker'
  s.version = Classmaker::VERSION
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = false
  s.summary = "Generate Java classes, interfaces, and unit tests"
  s.description = "Generate Java classes, interfaces, and unit tests"
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rack-test'
  s.add_development_dependency 'rcov' if RUBY_VERSION.split('.')[1].to_i == 8
  s.add_development_dependency 'simplecov' if RUBY_VERSION.split('.')[1].to_i == 9
  s.author = "Sean Schulte"
  s.email = "sirsean@gmail.com"
  s.homepage = "http://vikinghammer.com"
  s.required_ruby_version = ">= 1.8.6"
  s.files = %w(README.md Rakefile) + Dir["{lib,script,spec,doc,cert_data}/**/*"]
  s.test_files= Dir.glob('test/*_spec.rb')
  s.executables = ["classmaker"]
  s.require_path = "lib"
end

