# frozen_string_literal: true

source 'https://rubygems.org'

eval_gemfile 'Gemfile.devtools'

gemspec

group :test do
  gem 'dry-monads', '~> 1.2.0'
  gem 'rspec', '~> 3.8'
end

group :tools do
  gem 'yard'
  gem 'byebug', platform: :mri
  gem 'pry'
end
