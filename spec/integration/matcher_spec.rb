require "dry-monads"
require "dry/result_matcher/case"
require "dry/result_matcher/matcher"

RSpec.describe Dry::ResultMatcher::Matcher do
  context "with match cases provided" do
    let(:success_case) {
      Dry::ResultMatcher::Case.new(
        match: -> pattern, result { result.right? },
        resolve: -> result { result.value },
      )
    }

    let(:failure_case) {
      Dry::ResultMatcher::Case.new(
        match: -> pattern, result { result.left? },
        resolve: -> result { result.value },
      )
    }

    let(:matcher) {
      Dry::ResultMatcher::Matcher.new(
        success: success_case,
        failure: failure_case,
      )
    }

    def call_match(input)
      matcher.(input) do |m|
        m.success do |v|
          "Success: #{v}"
        end

        m.failure do |v|
          "Failure: #{v}"
        end
      end
    end

    it "matches on success" do
      input = Dry::Monads::Right("Yes!")
      expect(call_match(input)).to eq "Success: Yes!"
    end

    it "matches on failure" do
      input = Dry::Monads::Left("No!")
      expect(call_match(input)).to eq "Failure: No!"
    end
  end
end
