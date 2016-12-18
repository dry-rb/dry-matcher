module Dry
  class Matcher
    # {Case} object contains logic for pattern matching and resolving result
    # from matched pattern
    class Case
      DEFAULT_RESOLVE = -> result { result }

      # @param match [#call] callable used to test given pattern against value
      # @param resolve [#call] callable used to resolve value into a result
      def initialize(match:, resolve: DEFAULT_RESOLVE)
        @match = match
        @resolve = resolve
      end

      # Tests whether `value` (with optional `*pattern`) matches pattern using
      # callable given to {#initialize} as `match:` argument
      #
      # @param [Object] value
      # @param [<Object>] pattern optional pattern given after the `value` to
      #   `match:` callable
      # @return [Boolean]
      def matches?(value, *pattern)
        @match.(value, *pattern)
      end

      # Resolves result from `value` using callable given to {#initialize}
      # as `resolve:` argument
      #
      # @param [Object] value
      # @return [Object] result resolved from given `value`
      def resolve(value)
        @resolve.(value)
      end
    end
  end
end
