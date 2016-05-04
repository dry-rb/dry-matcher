require "dry-monads"

module Dry
  module ResultMatcher
    class Matcher
      attr_reader :result
      attr_reader :output

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
        result.right?
      end

      def is_a_left?
        result.left?
      end
    end
  end
end
