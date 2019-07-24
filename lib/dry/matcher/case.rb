# frozen_string_literal: true

module Dry
  class Matcher
    # {Case} object contains logic for pattern matching and resolving result
    # from matched pattern
    class Case
      DEFAULT_RESOLVE = -> result { result }

      # @param match [#call] callable used to test given pattern against value
      # @param resolve [#call] callable used to resolve value into a result
      def initialize(match: Undefined, resolve: DEFAULT_RESOLVE, &block)
        if block
          @match = block
        else
          @match = proc do |value, patterns|
            if match.(value, *patterns)
              resolve.(value)
            else
              Undefined
            end
          end
        end
      end

      # @param [Object] value Value to match
      # @param [Array<Object>] patterns Optional list of patterns to match against
      # @yieldparam [Object] v Resolved value if match succeeds
      # @return [Object,Dry::Core::Constants::Undefined] Either the yield result
      #   or Undefined if match wasn't successful
      def call(value, patterns = EMPTY_ARRAY, &block)
        Undefined.map(@match.(value, patterns), &block)
      end
    end
  end
end
