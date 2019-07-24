# frozen_string_literal: true

module Dry
  class Matcher
    NonExhaustiveMatchError = Class.new(StandardError)

    # {Evaluator} is used in {Dry::Matcher#call Dry::Matcher#call} block to handle different {Case}s
    class Evaluator < BasicObject
      # @param [Object] result
      # @param [Hash{Symbol => Case}] cases
      def initialize(result, cases)
        @cases = cases
        @result = result

        @unhandled_cases = @cases.keys.map(&:to_sym)
      end

      def call
        yield self

        ensure_exhaustive_match

        @output if defined? @output
      end

      # Checks whether `cases` given to {#initialize} contains one called `name`
      # @param [String] name
      # @param [Boolean] include_private
      # @return [Boolean]
      def respond_to_missing?(name, _include_private = false)
        @cases.key?(name)
      end

      # Handles method `name` called after one of the keys in `cases` hash given
      # to {#initialize}
      #
      # @param [String] name name of the case given to {#initialize} in `cases`
      #   argument
      # @param [Array] args pattern that would be tested for match and used to
      #   resolve result
      # @param [#call] block callable that will processes resolved value
      #   from matched pattern
      # @yieldparam [Object] v resolved value
      # @return [Object] result of calling `block` on value resolved from `args`
      #   if `args` pattern was matched by the given case called `name`
      # @raise [NoMethodError] if there was no case called `name` given to
      #   {#initialize} in `cases` hash
      def method_missing(name, *args, &block)
        kase = @cases.fetch(name) { return super }

        @unhandled_cases.delete name

        unless defined? @output
          kase.(@result, args) do |result|
            @output = yield(result)
          end
        end
      end

      private

      def ensure_exhaustive_match
        if @unhandled_cases.any?
          ::Kernel.raise NonExhaustiveMatchError, "cases +#{@unhandled_cases.join(', ')}+ not handled"
        end
      end
    end
  end
end
