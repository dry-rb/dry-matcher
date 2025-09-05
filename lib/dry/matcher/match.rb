# frozen_string_literal: true

require "dry/matcher"

# rubocop:disable Style/CaseEquality
module Dry
  class Matcher
    PatternMatch = proc do |value, patterns|
      if patterns.empty?
        value
      elsif value.is_a?(::Array) && patterns.any? { |p| p === value[0] }
        value
      elsif patterns.any? { |p| p === value }
        # rubocop:enable Lint/DuplicateBranch
        value
      else
        Undefined
      end
    end
  end
end
# rubocop:enable Style/CaseEquality
