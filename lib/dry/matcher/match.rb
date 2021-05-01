# frozen_string_literal: true

require 'dry/matcher'

module Dry
  class Matcher
    PatternMatch = ::Proc.new do |value, patterns|
      if patterns.empty?
        value
      elsif value.is_a?(::Array) && patterns.any? { |p| p === value[0] }
        value
      elsif patterns.any? { |p| p === value }
        value
      else
        Undefined
      end
    end
  end
end
