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
        return output unless result.right?
        @output = block.call(result.value)
      end

      def failure(&block)
        return output unless result.left?
        @output = block.call(result.value)
      end
    end
  end
end
