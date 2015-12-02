require "kleisli"

RSpec.describe "MatchEitherResult" do
  subject(:match) {
    MatchEitherResult(result) do |m|
      m.success do |v|
        "Matched success: #{v}"
      end

      m.failure do |v|
        "Matched failure: #{v}"
      end
    end
  }

  context "successful result" do
    let(:result) { Right("a success") }

    it "matches on success" do
      expect(match).to eq "Matched success: a success"
    end
  end

  context "failed result" do
    let(:result) { Left("a failure") }

    it "matches on failure" do
      expect(match).to eq "Matched failure: a failure"
    end
  end
end
