module Dry
  module ResultMatcher
    class Evaluator < BasicObject
      def initialize(result, cases)
        @cases = cases
        @result = result
        @matched = false
        @output = nil
      end

      def call(&block)
        block.call(self)
        @output
      end

      def respond_to_missing?(name, include_private = false)
        @cases.key?(name) || super
      end

      def method_missing(name, *args, &block)
        return super unless @cases.key?(name)

        handle_case @cases[name], *args, &block
      end

      private

      def handle_case(kase, *pattern, &block)
        return @output if @matched

        if kase.matches?(@result, *pattern)
          @matched = true
          @output = block.call(kase.resolve(@result))
        end
      end
    end
  end
end
