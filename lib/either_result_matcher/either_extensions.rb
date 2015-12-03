require "kleisli"
require "either_result_matcher"

module EitherResultMatcher
  module EitherExtensions
    def match(&block)
      MatchEitherResult(self, &block)
    end
  end
end

Kleisli::Either.include EitherResultMatcher::EitherExtensions
