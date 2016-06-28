module Dry
  module ResultMatcher
    class Case
      def initialize(match:, resolve:)
        @match = match
        @resolve = resolve
      end

      def matches?(pattern, value)
        @match.(pattern, value)
      end

      def resolve(value)
        @resolve.(value)
      end
    end
  end
end