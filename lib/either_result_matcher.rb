require "either_result_matcher/matcher"

def MatchEitherResult(result, &block)
  block.call(EitherResultMatcher::Matcher.new(result))
end
