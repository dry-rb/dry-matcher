# dry-result_matcher

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
