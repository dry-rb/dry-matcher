require "dry/matcher"

module Dry
  class Matcher
    # Built-in {Matcher} ready to use with `Either` or `Try` monads from
    # [dry-monads](/gems/dry-monads) or any other compatible gems.
    #
    # Provides {Case}s for two matchers:
    # * `:success` matches `Dry::Monads::Either::Right`
    #   and `Dry::Monads::Try::Success` (or any other monad that responds to
    #   `#to_either` returning either monad that is `#right?`)
    # * `:failure` matches `Dry::Monads::Either::Left` and
    #   `Dry::Monads::Try::Failure` (or any other monad that responds to
    #   `#to_either` returning either monad that is `#left?`)
    #
    # @return [Dry::Matcher]
    #
    # @example Usage with `dry-monads`
    #   require 'dry-monads'
    #   require 'dry/matcher/either_matcher'
    #
    #   value = Dry::Monads::Either::Right.new('success!')
    #
    #   Dry::Matcher::EitherMatcher.(value) do |m|
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
    #   require 'dry/matcher/either_matcher'
    #
    #   class CustomBooleanMonad
    #     def initialize(value); @value = value; end
    #     attr_reader :value
    #     alias_method :right?, :value
    #     def left?; !right?; end
    #     def to_either; self; end
    #   end
    #
    #   value = CustomBooleanMonad.new(nil)
    #
    #   Dry::Matcher::EitherMatcher.(value) do |m|
    #     m.success { |v| "#{v.inspect} is truthy" }
    #     m.failure { |v| "#{v.inspect} is falsey" }
    #   end # => "nil is falsey"
    EitherMatcher = Dry::Matcher.new(
      success: Case.new(
        match: -> result, *pattern {
          result = result.to_either
          result.right?
        },
        resolve: -> result {
          result = result.to_either
          result.value!
        },
      ),
      failure: Case.new(
        match: -> result, *pattern {
          result = result.to_either
          result.left?
        },
        resolve: -> result {
          result = result.to_either
          result.left
        },
      )
    )
  end
end
