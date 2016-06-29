require "dry-monads"
require "dry/matcher/either_matcher"

RSpec.describe "Dry::Matcher::EitherMatcher" do
  describe "external matching" do
    subject(:match) {
      Dry::Matcher::EitherMatcher.(result) do |m|
        m.success do |v|
          "Matched success: #{v}"
        end

        m.failure do |v|
          "Matched failure: #{v}"
        end
      end
    }

    context "successful result" do
      let(:result) { Dry::Monads::Right("a success") }

      it "matches on success" do
        expect(match).to eq "Matched success: a success"
      end
    end

    context "failed result" do
      let(:result) { Dry::Monads::Left("a failure") }

      it "matches on failure" do
        expect(match).to eq "Matched failure: a failure"
      end
    end

    context "result convertible to either" do
      context "converts to success" do
        let(:result) {
          Dry::Monads::Try.lift([StandardError], -> { 'a success' })
        }

        it "matches on success" do
          expect(match).to eq "Matched success: a success"
        end
      end

      context "converts to failure" do
        let(:result) {
          Dry::Monads::Try.lift([StandardError], -> { raise('a failure') })
        }

        it "matches on failure" do
          expect(match).to eq "Matched failure: a failure"
        end
      end
    end
  end
end
