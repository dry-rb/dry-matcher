require "dry-monads"
require "kleisli"

module Dry
  module ResultMatcher
    class Matcher
      attr_reader :result
      attr_reader :output

      RIGHT = [
        Dry::Monads::Either::Right,
        Kleisli::Either::Right
      ].freeze

      LEFT = [
        Dry::Monads::Either::Left,
        Kleisli::Either::Left
      ].freeze

      def initialize(result)
        @result = result
      end

      def success(&block)
        return output unless is_a_right?
        @output = block.call(result.value)
      end

      def failure(&block)
        return output unless is_a_left?
        @output = block.call(result.value)
      end

    private

      def is_a_right?
        RIGHT.include?(result.class)
      end

      def is_a_left?
        LEFT.include?(result.class)
      end
    end
  end
end
