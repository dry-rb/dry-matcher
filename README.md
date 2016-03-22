[gitter]: https://gitter.im/dry-rb/chat
[gem]: https://rubygems.org/gems/dry-result_matcher
[travis]: https://travis-ci.org/dry-rb/dry-result_matcher
[code_climate]: https://codeclimate.com/github/dry-rb/dry-result_matcher
[inch]: http://inch-ci.org/github/dry-rb/dry-result_matcher

# dry-result_matcher [![Join the Gitter chat](https://badges.gitter.im/Join%20Chat.svg)][gitter]

[![Gem Version](https://img.shields.io/gem/v/dry-result_matcher.svg)][gem]
[![Build Status](https://travis-ci.org/dry-rb/dry-result_matcher.svg?branch=master)][travis]
[![Code Climate](https://img.shields.io/codeclimate/github/dry-rb/dry-result_matcher.svg)][code_climate]
[![API Documentation Coverage](http://inch-ci.org/github/dry-rb/dry-result_matcher.svg)][inch]

An expressive, all-in-one API for operating on [Kleisli](https://github.com/txus/kleisli) `Either` results.

## Usage

Operate an an `Either` object from the outside:

```ruby
result = Right("some result")

Dry::ResultMatcher.match(result) do |m|
  m.success do |v|
    "Success: #{v}"
  end

  m.failure do |v|
    "Failure: #{v}"
  end
end
```

Or extend your own `Either`-returning classes to support result match blocks:

```ruby
class MyOperation
  include Dry::ResultMatcher.for(:call)

  def call
    Right("some result")
  end
end

my_op = MyOperation.new
my_op.call() do |m|
  m.success do |v|
    "Success: #{v}"
  end

  m.failure do |v|
    "Failure: #{v}"
  end
end
```

## License

Copyright © 2015-2016 [Icelab](http://icelab.com.au/). dry-result_matcher is free software, and may be redistributed under the terms specified in the [license](LICENSE.md).
