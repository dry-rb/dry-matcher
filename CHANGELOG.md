# 0.4.0 / 2016-06-08

## Added

* Support convertible result objects responding to `#to_either` (ttdonovan)

## Changed

* Expect monads from [dry-monads](https://github.com/dry-rb/dry-monads) instead of [Kleisli](https://github.com/txus/kleisli) (ttdonovan)

[Compare v0.3.0...v0.4.0](https://github.com/dry-rb/dry-result_matcher/compare/v0.3.0...v0.4.0)

# 0.3.0 / 2016-03-23

## Changed

* Renamed to `dry-result_matcher`. Match results using `Dry::ResultMatcher.match` or extend your own classes with `Dry::ResultMatcher.for`.

[Compare v0.2.0...v0.3.0](https://github.com/dry-rb/dry-result_matcher/compare/v0.2.0...v0.3.0)

# 0.2.0 / 2016-02-10

## Added

* Added `EitherResultMatcher.for(*methods)` to return a module wrapping the specified methods (returning an `Either`) with the match block API. Example usage, in a class with a `#call` method: `include EitherResultMatcher.for(:call)`.

[Compare v0.1.0...v0.22.0](https://github.com/dry-rb/dry-result_matcher/compare/v0.1.0...v0.2.0)

# 0.1.0 / 2015-12-03

Initial release.
