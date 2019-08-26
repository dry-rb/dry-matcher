# frozen_string_literal: true

require 'dry/matcher'

module Dry
  class Matcher
    match = lambda do |value, patterns|
      return value if patterns.empty?
      return value if value.is_a?(::Array) && patterns.any? { |p| p === value[0] }
      return value if patterns.any? { |p| p === value }

      Undefined
    end

    # Built-in {Matcher} ready to use with `Result` or `Try` monads from
    # [dry-monads](/gems/dry-monads) or any other compatible gems.
    #
    # Provides {Case}s for two matchers:
    # * `:success` matches `Dry::Monads::Result::Success`
    #   and `Dry::Monads::Try::Value` (or any other monad that responds to
    #   `#to_result` returning result monad that is `#success?`)
    # * `:failure` matches `Dry::Monads::Result::Failure` and
    #   `Dry::Monads::Try::Error` (or any other monad that responds to
    #   `#to_result` returning result monad that is `#failure?`)
    #
    # @return [Dry::Matcher]
    #
    # @example Usage with `dry-monads`
    #   require 'dry/monads/result'
    #   require 'dry/matcher/result_matcher'
    #
    #   value = Dry::Monads::Result::Success.new('success!')
    #
    #   Dry::Matcher::ResultMatcher.(value) do |m|
    #     m.success do |v|
    #       "Yay: #{v}"
    #     end
    #
    #     m.failure do |v|
    #       "Boo: #{v}"
    #     end
    #   end #=> "Yay: success!"
    #
    # @example Usage with custom monad
    #   require 'dry/matcher/result_matcher'
    #
    #   class CustomBooleanMonad
    #     def initialize(value); @value = value; end
    #     attr_reader :value
    #     alias_method :success?, :value
    #     def failure?; !success?; end
    #     def to_result; self; end
    #   end
    #
    #   value = CustomBooleanMonad.new(nil)
    #
    #   Dry::Matcher::ResultMatcher.(value) do |m|
    #     m.success { |v| "#{v.inspect} is truthy" }
    #     m.failure { |v| "#{v.inspect} is falsey" }
    #   end # => "nil is falsey"
    #
    # @example Usage with error codes
    #   value = Dry::Monads::Result::Failure.new([:invalid, :reasons])
    #
    #   Dry::Matcher::ResultMatcher.(value) do |m|
    #     m.success do |v|
    #       "Yay: #{v}"
    #     end
    #
    #     m.failure(:not_found) do
    #       "No such thing"
    #     end
    #
    #     m.failure(:invalid) do |_code, errors|
    #       "Cannot be done: #{errors.inspect}"
    #     end
    #   end #=> "Cannot be done: :reasons"
    #
    ResultMatcher = Dry::Matcher.new(
      success: Case.new do |result, patterns|
        result = result.to_result

        if result.success?
          match.call(result.value!, patterns)
        else
          Undefined
        end
      end,
      failure: Case.new do |result, patterns|
        result = result.to_result

        if result.failure?
          match.call(result.failure, patterns)
        else
          Undefined
        end
      end
    )
  end
end
