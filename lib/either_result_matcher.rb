require "either_result_matcher/matcher"

def MatchEitherResult(result, &block)
  block.call(EitherResultMatcher::Matcher.new(result))
end

module EitherResultMatcher
  def self.for(*match_methods)
    matchers_mod = Module.new do
      match_methods.each do |match_method|
        define_method(match_method) do |*args, &block|
          result = super(*args)

          if block
            MatchEitherResult(result, &block)
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
