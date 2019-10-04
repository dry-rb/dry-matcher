---
title: Class enhancement
layout: gem-single
name: dry-matcher
---

You can offer a match block API from your own methods using `Dry::Matcher.for`:

```ruby
require "dry-matcher"

# First, build a matcher or use an existing one (like dry-matcher's ResultMatcher)
MyMatcher = Dry::Matcher.new(...)

# Offer it from your class with `Dry::Matcher.for`
class MyOperation
  include Dry::Matcher.for(:call, with: MyMatcher)

  def call
    # return a value here
  end
end

# And now `MyOperation#call` offers the matcher block API
operation = MyOperation.new

operation.() do |m|
  # Use the matcher's API here
end
```
