require "dry/result_matcher/matcher"
require "dry/result_matcher/either_matcher"

module Dry
  module ResultMatcher
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
  end
end
