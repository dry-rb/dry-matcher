---
title: Introduction
description: Expressive match API for operating on computation results
layout: gem-single
type: gem
name: dry-matcher
sections:
  - class-enhancement
  - result-matcher
---

dry-matcher offers flexible, expressive pattern matching for Ruby.

You can build your own matcher or use the out-of-the-box support for matching on [dry-monads](/gems/dry-monads) `Result` values.

## Building a matcher

To build your own matcher, create a series of "case" objects with their own matching and resolving logic:

```ruby
require "dry-matcher"

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
```

Then use these cases as part of an API to match on results:

```ruby
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

Cases are executed in order. The first match wins and halts subsequent matching.

```ruby
my_failure = [:err, :not_found, "missing!"]

result = matcher.(my_failure) do |m|
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

result # => "Oops, not found: missing!"
```
