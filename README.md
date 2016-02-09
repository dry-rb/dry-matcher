# Either Result Matcher

## Usage

Operate an an `Either` object from the outside:

```ruby
result = Right("some result")

MatchEitherResult(result) do |m|
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
  include EitherResultMatcher.for(:call)

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
