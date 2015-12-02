# Either Result Matcher

## Usage

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
