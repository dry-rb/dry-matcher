lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "dry/matcher/version"

Gem::Specification.new do |spec|
  spec.name           = "dry-matcher"
  spec.version        = Dry::Matcher::VERSION
  spec.authors        = ["Tim Riley"]
  spec.email          = ["tim@icelab.com.au"]
  spec.license        = "MIT"

  spec.summary        = "Flexible, expressive pattern matching for Ruby"
  spec.description    = spec.summary
  spec.homepage       = "http://dry-rb.org/gems/dry-matcher"

  spec.files          = Dir["README.md", "LICENSE.md", "CHANGELOG.md", "Gemfile", "Rakefile", "lib/**/*", "spec/**/*"]
  spec.require_paths  = ["lib"]

  spec.required_ruby_version = ">= 2.4.0"

  spec.add_runtime_dependency "dry-core", ">= 0.4.7"
end
