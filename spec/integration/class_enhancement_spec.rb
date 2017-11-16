require "dry-monads"
require "dry/matcher/result_matcher"

RSpec.describe "Class enhancement with Dry::Matcher.for" do
  let(:operation) {
    Class.new do
      include Dry::Matcher.for(:call, with: Dry::Matcher::ResultMatcher)

      def call(bool)
        bool ? Dry::Monads::Success("a success") : Dry::Monads::Failure("a failure")
      end
    end.new
  }

  describe "match blocks" do
    subject(:match) {
      operation.call(input) do |m|
        m.success do |v|
          "Matched success: #{v}"
        end

        m.failure do |v|
          "Matched failure: #{v}"
        end
      end
    }

    context "successful result" do
      let(:input) { true }

      it "matches on success" do
        expect(match).to eq "Matched success: a success"
      end
    end

    context "failed result" do
      let(:input) { false }

      it "matches on failure" do
        expect(match).to eq "Matched failure: a failure"
      end
    end
  end

  describe "without match blocks" do
    subject(:result) { operation.call(input) }

    context "successful result" do
      let(:input) { true }

      it "returns the result" do
        expect(result).to eq Dry::Monads::Success("a success")
      end
    end

    context "failed result" do
      let(:input) { false }

      it "returns the result" do
        expect(result).to eq Dry::Monads::Failure("a failure")
      end
    end
  end
end
