# frozen_string_literal: true

require "dry/matcher"
require "dry/matcher/match"

module Dry
  class Matcher
    # Built-in {Matcher} ready to use with `Maybe` monad from
    # [dry-monads](/gems/dry-monads) or any other compatible gems.
    #
    # Provides {Case}s for two matchers:
    # * `:some` matches `Dry::Monads::Maybe::Some`
    # * `:none` matches `Dry::Monads::Maybe::None`
    #
    # @return [Dry::Matcher]
    #
    # @example Usage with `dry-monads`
    #   require 'dry/monads'
    #   require 'dry/matcher/maybe_matcher'
    #
    #   value = Dry::Monads::Maybe.new('there is a value!')
    #
    #   Dry::Matcher::MaybeMatcher.(value) do |m|
    #     m.some do |v|
    #       "Yay: #{v}"
    #     end
    #
    #     m.none do
    #       "Boo: none"
    #     end
    #   end #=> "Yay: there is a value!"
    #
    #
    # @example Usage with specific types
    #   value = Dry::Monads::Maybe.new([200, :ok])
    #
    #   Dry::Matcher::MaybeMatcher.(value) do |m|
    #     m.some(200, :ok) do |code, value|
    #       "Yay: #{value}"
    #     end
    #
    #     m.none do
    #       "Boo: none"
    #     end
    #   end #=> "Yay: :ok"
    #
    MaybeMatcher = Dry::Matcher.new(
      some: Case.new { |maybe, patterns|
        if maybe.none?
          Undefined
        else
          Dry::Matcher::PatternMatch.(maybe.value!, patterns)
        end
      },
      none: Case.new { |maybe|
        if maybe.some?
          Undefined
        end
      }
    )
  end
end
