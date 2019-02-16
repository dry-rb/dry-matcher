require "dry/monads/result"
require "dry/monads/try"
require "dry/matcher/result_matcher"

RSpec.describe "Dry::Matcher::ResultMatcher" do
  describe "external matching" do
    subject(:match) {
      Dry::Matcher::ResultMatcher.(result) do |m|
        m.success do |v|
          "Matched success: #{v}"
        end

        m.failure do |v|
          "Matched failure: #{v}"
        end
      end
    }

    context "successful result" do
      let(:result) { Dry::Monads::Success("a success") }

      it "matches on success" do
        expect(match).to eq "Matched success: a success"
      end
    end

    context "failed result" do
      let(:result) { Dry::Monads::Failure("a failure") }

      it "matches on failure" do
        expect(match).to eq "Matched failure: a failure"
      end
    end

    context "result convertible to result" do
      context "converts to success" do
        let(:result) {
          Dry::Monads::Try.run([StandardError], -> { 'a success' })
        }

        it "matches on success" do
          expect(match).to eq "Matched success: a success"
        end
      end

      context "converts to failure" do
        let(:result) {
          Dry::Monads::Try.run([StandardError], -> { raise('a failure') })
        }

        it "matches on failure" do
          expect(match).to eq "Matched failure: a failure"
        end
      end
    end
  end
end
