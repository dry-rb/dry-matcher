# frozen_string_literal: true

# this file is synced from dry-rb/template-gem project

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "dry/matcher/version"

Gem::Specification.new do |spec|
  spec.name          = "dry-matcher"
  spec.authors       = ["Tim Riley", "Nikita Shilnikov"]
  spec.email         = ["tim@icelab.com.au", "fg@flashgordon.ru"]
  spec.license       = "MIT"
  spec.version       = Dry::Matcher::VERSION.dup

  spec.summary       = "Flexible, expressive pattern matching for Ruby"
  spec.description   = spec.summary
  spec.homepage      = "https://dry-rb.org/gems/dry-matcher"
  spec.files         = Dir["CHANGELOG.md", "LICENSE", "README.md", "dry-matcher.gemspec", "lib/**/*"]
  spec.bindir        = "bin"
  spec.executables   = []
  spec.require_paths = ["lib"]

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["changelog_uri"]     = "https://github.com/dry-rb/dry-matcher/blob/master/CHANGELOG.md"
  spec.metadata["source_code_uri"]   = "https://github.com/dry-rb/dry-matcher"
  spec.metadata["bug_tracker_uri"]   = "https://github.com/dry-rb/dry-matcher/issues"

  if defined? JRUBY_VERSION
    spec.required_ruby_version = ">= 2.5.0"
  else
    spec.required_ruby_version = ">= 2.6.0"
  end

  # to update dependencies edit project.yml
  spec.add_runtime_dependency "dry-core", "~> 0.4", ">= 0.4.8"

  spec.add_development_dependency "rake"
end
