require "dry/matcher/case"
require "dry/matcher/evaluator"

module Dry
  # @see http://dry-rb.org/gems/dry-matcher
  class Matcher
    # Generates a module containing pattern matching for methods listed in
    # `match_methods` argument with behavior defined by `with` matcher
    #
    # @param [<Symbol>] match_methods
    # @param [Dry::Matcher] with
    # @return [Module]
    #
    # @example Usage with `dry-monads`
    #   class MonadicOperation
    #     include Dry::Matcher.for(:call, with: Dry::Matcher::ResultMatcher)
    #
    #     def call
    #       Dry::Monads::Result::Success.new('Success')
    #     end
    #   end
    #
    #   operation = MonadicOperation.new
    #
    #   operation.call do |m|
    #     m.success { |v| "#{v} was successful!"}
    #     m.failure { |v| "#{v} has failed!"}
    #   end #=> "Success was successful"
    def self.for(*match_methods, with:)
      matcher = with

      matchers_mod = Module.new do
        match_methods.each do |match_method|
          define_method(match_method) do |*args, &block|
            result = super(*args)

            if block
              matcher.(result, &block)
            else
              result
            end
          end
        end
      end

      Module.new do
        const_set :Matchers, matchers_mod

        def self.included(klass)
          klass.prepend const_get(:Matchers)
        end
      end
    end

    # @return [Hash{Symbol => Case}]
    attr_reader :cases

    # @param [Hash{Symbol => Case}] cases
    def initialize(cases = {})
      @cases = cases
    end

    # Evaluate {#cases}' matchers and returns a result of block given to
    # corresponding case matcher
    #
    # @param [Object] result value that would be tested for matches with given {#cases}
    # @param [Object] block
    # @yieldparam [Evaluator] m
    # @return [Object] value returned from the block given to method called
    #   after matched pattern
    #
    # @example Usage with `dry-monads`
    #   require 'dry-monads'
    #   require 'dry/matcher/result_matcher'
    #
    #   value = Dry::Monads::Result::Failure.new('failure!')
    #
    #   Dry::Matcher::ResultMatcher.(value) do |m|
    #     m.success { |v| "Yay: #{v}" }
    #     m.failure { |v| "Boo: #{v}" }
    #   end #=> "Boo: failure!"
    def call(result, &block)
      Evaluator.new(result, cases).call(&block)
    end
  end
end
