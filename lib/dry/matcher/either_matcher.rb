# frozen_string_literal: true

require 'dry/core/deprecations'
require 'dry/matcher/result_matcher'

module Dry
  class Matcher
    extend Dry::Core::Deprecations[:'dry-matcher']

    EitherMatcher = ResultMatcher

    deprecate_constant(:EitherMatcher, message: 'Dry::Matcher::ResultMatcher')
  end
end
