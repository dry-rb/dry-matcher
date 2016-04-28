RSpec.describe Dry::ResultMatcher do
  include Dry::Monads::Either::Mixin

  describe 'Matcher RIGHT' do
    subject { described_class::Matcher::RIGHT }
    it { is_expected.to eq([Dry::Monads::Either::Right, Kleisli::Either::Right]) }
  end

  describe 'Matcher LEFT' do
    subject { described_class::Matcher::LEFT }
    it { is_expected.to eq([Dry::Monads::Either::Left, Kleisli::Either::Left]) }
  end

  describe "external matching" do
    subject(:match) {
      Dry::ResultMatcher.match(result) do |m|
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

  describe "class enhancement" do
    let(:operation) {
      Class.new do
        include Dry::ResultMatcher.for(:call)

        def call(bool)
          bool ? Right("a success") : Left("a failure")
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
          expect(result).to eq Right("a success")
        end
      end

      context "failed result" do
        let(:input) { false }

        it "returns the result" do
          expect(result).to eq Left("a failure")
        end
      end
    end
  end
end
