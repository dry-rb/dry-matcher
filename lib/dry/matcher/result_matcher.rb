require "dry/matcher"

module Dry
  class Matcher
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
    #   require 'dry-monads'
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
    ResultMatcher = Dry::Matcher.new(
      success: Case.new(
        match: -> result, *pattern {
          result = result.to_result
          result.success?
        },
        resolve: -> result {
          result = result.to_result
          result.value!
        },
      ),
      failure: Case.new(
        match: -> result, *pattern {
          result = result.to_result
          result.failure?
        },
        resolve: -> result {
          result = result.to_result
          result.failure
        },
      )
    )
  end
end
