# 0.5.1 / 2016-07-06

## Fixed

- Fixed handling of calls to non-existent cases within a matcher block (timriley)

# 0.5.0 / 2016-06-30

## Added

- Added support for building custom matchers, with an any number of match cases, each offering their own matching and resolving logic. This is now the primary API for dry-matcher. (timriley)

    ```ruby
    # Match `[:ok, some_value]` for success
    success_case = Dry::Matcher::Case.new(
      match: -> value { value.first == :ok },
      resolve: -> value { value.last }
    )

    # Match `[:err, some_error_code, some_value]` for failure
    failure_case = Dry::Matcher::Case.new(
      match: -> value, *pattern {
        value[0] == :err && (pattern.any? ? pattern.include?(value[1]) : true)
      },
      resolve: -> value { value.last }
    )

    # Build the matcher
    matcher = Dry::Matcher.new(success: success_case, failure: failure_case)

    # Then put it to use
    my_success = [:ok, "success!"]

    result = matcher.(my_success) do |m|
      m.success do |v|
        "Yay: #{v}"
      end

      m.failure :not_found do |v|
        "Oops, not found: #{v}"
      end

      m.failure do |v|
        "Boo: #{v}"
      end
    end

    result # => "Yay: success!"
    ```

## Changed

- Renamed to `dry-matcher`, since this is now a flexible, general purpose pattern matching API. All components are now available under the `Dry::Matcher` namespace. (timriley)
- `Dry::Matcher.for` requires a matcher object to be passed when being included in a class:

    ```ruby
    MyMatcher = Dry::Matcher.new(...)

    class MyOperation
      include Dry::Matcher.for(:call, with: MyMatcher)

      def call
      end
    end
    ```
- The previous `Dry::ResultMatcher.match` behaviour (for matching `Either` monads) has been moved to `Dry::Matcher::EitherMatcher.call`

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
