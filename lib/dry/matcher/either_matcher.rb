require "dry/matcher/case"

module Dry
  class Matcher
    EitherMatcher = Dry::Matcher.new(
      success: Case.new(
        match: -> result, *pattern {
          result = result.to_either
          result.right?
        },
        resolve: -> result {
          result = result.to_either
          result.value
        },
      ),
      failure: Case.new(
        match: -> result, *pattern {
          result = result.to_either
          result.left?
        },
        resolve: -> result {
          result = result.to_either
          result.value
        },
      )
    )
  end
end
