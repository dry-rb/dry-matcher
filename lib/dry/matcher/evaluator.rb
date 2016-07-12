module Dry
  class Matcher
    NonExhaustiveMatchError = Class.new(StandardError)

    class Evaluator < BasicObject
      def initialize(result, cases)
        @cases = cases
        @result = result

        @unhandled_cases = @cases.keys.map(&:to_sym)
        @matched = false
        @output = nil
      end

      def call
        yield self

        ensure_exhaustive_match

        @output
      end

      def respond_to_missing?(name, include_private = false)
        @cases.key?(name)
      end

      def method_missing(name, *args, &block)
        return super unless @cases.key?(name)

        @unhandled_cases.delete name
        handle_case @cases[name], *args, &block
      end

      private

      def ensure_exhaustive_match
        if @unhandled_cases.any?
          ::Kernel.raise NonExhaustiveMatchError, "cases +#{@unhandled_cases.join(', ')}+ not handled"
        end
      end

      def handle_case(kase, *pattern)
        return @output if @matched

        if kase.matches?(@result, *pattern)
          @matched = true
          @output = yield(kase.resolve(@result))
        end
      end
    end
  end
end
