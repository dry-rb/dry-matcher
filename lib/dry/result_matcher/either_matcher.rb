require "dry/result_matcher/case"

module Dry
  module ResultMatcher
    EitherMatcher = Dry::ResultMatcher::Matcher.new(
      success: Case.new(
        match: -> result, *pattern {
          result = result.to_either if result.respond_to?(:to_either)
          result.right?
        },
        resolve: -> result {
          result = result.to_either if result.respond_to?(:to_either)
          result.value
        },
      ),
      failure: Case.new(
        match: -> result, *pattern {
          result = result.to_either if result.respond_to?(:to_either)
          result.left?
        },
        resolve: -> result {
          result = result.to_either if result.respond_to?(:to_either)
          result.value
        },
      )
    )
  end
end
