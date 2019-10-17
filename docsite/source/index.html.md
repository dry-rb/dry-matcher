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

To build your own matcher, create a series of "case" objects with their own resolving logic. First argument of the case block is the value to match, second argument is the list of patterns (see below). The block must either return the result or `Dry::Matcher::Undefined` if the has no match. The latter signals dry-matcher to try the next case.

```ruby
require "dry-matcher"

# Match `[:ok, some_value]` for success
success_case = Dry::Matcher::Case.new do |(code, value), _|
  if code.equal?(:ok)
    value
  else
    # this is a constant from dry/core/constants
    Dry::Matcher::Undefined
  end
end

# Match `[:err, some_error_code, some_value]` for failure
failure_case = Dry::Matcher::Case.new do |(code, value), patterns|
  if code.equal?(:err) && (patterns.empty? || patterns.include?(value)
    value
  else
    Dry::Matcher::Undefined
  end
end

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

  # :not_found and :lost are patterns
  m.failure :not_found, :lost do |v|
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
