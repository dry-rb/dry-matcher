# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

gem 'bundler'
gem 'rake'
gem 'yard'

group :test do
  gem 'codeclimate-test-reporter'
  gem 'dry-monads', '~> 1.2.0'
  gem 'rspec', '~> 3.8'
  gem 'simplecov'
end

group :tools do
  gem 'byebug', platform: :mri
  gem 'pry'
  gem 'rubocop', require: false
  gem 'ossy', git: 'https://github.com/solnic/ossy.git', branch: 'master'
end
