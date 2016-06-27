require "dry/result_matcher/case"
require "dry/result_matcher/matcher"

RSpec.describe "custom matches" do
  it "works as before" do
    success_case = Dry::ResultMatcher::Case.new(
      match: -> pattern, result { result.right? },
      resolve: -> result { result.value },
    )

    failure_case = Dry::ResultMatcher::Case.new(
      match: -> pattern, result { result.left? },
      resolve: -> result { result.value },
    )

    matcher = Dry::ResultMatcher::Matcher.new(
      success: success_case,
      failure: failure_case,
    )

    my_result = Dry::Monads::Either::Right.new("hi")

    output = matcher.(my_result) do |m|
      m.success do |v|
        "Success: #{v}"
      end

      m.failure do |v|
        "Failure: #{f}"
      end
    end

    expect(output).to eq "Success: hi"
  end
end
