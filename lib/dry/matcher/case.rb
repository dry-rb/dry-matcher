module Dry
  class Matcher
    class Case
      def initialize(match:, resolve:)
        @match = match
        @resolve = resolve
      end

      def matches?(value, *pattern)
        @match.(value, *pattern)
      end

      def resolve(value)
        @resolve.(value)
      end
    end
  end
end
