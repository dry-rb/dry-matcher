---
title: Result matcher
layout: gem-single
name: dry-matcher
---

dry-matcher provides a ready-to-use `ResultMatcher` for working with `Result` or `Try` monads from [dry-monads](/gems/dry-monads) or any other compatible gems.

```ruby
require "dry/monads/result"
require "dry/matcher/result_matcher"

value = Dry::Monads::Result::Success.new("success!")

result = Dry::Matcher::ResultMatcher.(value) do |m|
  m.success do |v|
    "Yay: #{v}"
  end

  m.failure do |v|
    "Boo: #{v}"
  end
end

result # => "Yay: success!"
```
