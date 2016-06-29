require "dry/result_matcher/evaluator"

module Dry
  module ResultMatcher
    class Matcher
      attr_reader :cases

      def initialize(cases = {})
        @cases = cases
      end

      def call(result, &block)
        Evaluator.new(result, cases).call(&block)
      end
    end
  end
end
