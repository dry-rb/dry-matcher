# 0.2.0 / 2016-02-10

## Added

* Added `EitherResultMatcher.for(*methods)` to return a module wrapping the specified methods (returning an `Either`) with the match block API. Example usage, in a class with a `#call` method: `include EitherResultMatcher.for(:call)`.

# 0.1.0 / 2015-12-03

Initial release.
