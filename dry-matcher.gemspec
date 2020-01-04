# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dry/matcher/version'

Gem::Specification.new do |spec|
  spec.name           = 'dry-matcher'
  spec.version        = Dry::Matcher::VERSION
  spec.authors        = ['Tim Riley', 'Nikita Shilnikov']
  spec.email          = ['tim@icelab.com.au', 'fg@flashgordon.ru']
  spec.license        = 'MIT'

  spec.summary        = 'Flexible, expressive pattern matching for Ruby'
  spec.description    = spec.summary
  spec.homepage       = 'http://dry-rb.org/gems/dry-matcher'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|bin)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.4.0'

  spec.add_runtime_dependency 'dry-core', '>= 0.4.8'
  spec.add_development_dependency 'rake', '~> 13.0'
end
