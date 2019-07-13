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

    context "multiple branch matching" do
      subject {
        Dry::Matcher::ResultMatcher.(result) do |on|
          on.success(:a) { "Matched specific success: :a" }
          on.success(:b) { "Matched specific success: :b" }
          on.success { |v| "Matched general success: #{v}" }
          on.failure(:a) { "Matched specific failure: :a" }
          on.failure(:b) { "Matched specific failure: :b" }
          on.failure { |v| "Matched general failure: #{v}" }
        end
      }

      context "specific success for :a" do
        let(:result) { Dry::Monads::Success(:a) }

        it { is_expected.to eq "Matched specific success: :a"}
      end

      context "specific success for :b" do
        let(:result) { Dry::Monads::Success(:b) }

        it { is_expected.to eq "Matched specific success: :b"}
      end

      context "general success result" do
        let(:result) { Dry::Monads::Success("a success") }

        it { is_expected.to eq "Matched general success: a success" }
      end

      context "specific failure for :a" do
        let(:result) { Dry::Monads::Failure(:a) }

        it { is_expected.to eq "Matched specific failure: :a"}
      end

      context "specific failure for :b" do
        let(:result) { Dry::Monads::Failure(:b) }

        it { is_expected.to eq "Matched specific failure: :b"}
      end

      context "general failure result" do
        let(:result) { Dry::Monads::Failure("a failure") }

        it { is_expected.to eq "Matched general failure: a failure" }
      end
    end

    context 'using ===' do
      subject {
        Dry::Matcher::ResultMatcher.(result) do |on|
          on.success(/done/) { |s| "Matched string by pattern: #{s.inspect}" }
          on.success(String) { |s| "Matched string success: #{s.inspect}" }
          on.success(Integer) { |n| "Matched integer success: #{n}" }
          on.success(Date, Time) { |t| "Matched date success: #{t.strftime('%Y-%m-%d')}" }
          on.success { |v| "Matched general success: #{v}" }
          on.failure(Integer) { |n| "Matched integer failure: #{n}" }
          on.failure { |v| "Matched general failure: #{v}" }
        end
      }

      context 'success string' do
        let(:result) { Dry::Monads::Success('nicely done') }

        it { is_expected.to eq 'Matched string by pattern: "nicely done"' }
      end

      context 'success string' do
        let(:result) { Dry::Monads::Success("yay") }

        it { is_expected.to eq 'Matched string success: "yay"' }
      end

      context 'success integer' do
        let(:result) { Dry::Monads::Success(3) }

        it { is_expected.to eq 'Matched integer success: 3' }
      end

      context 'failure integer' do
        let(:result) { Dry::Monads::Failure(3) }

        it { is_expected.to eq 'Matched integer failure: 3' }
      end

      context 'success date' do
        let(:result) { Dry::Monads::Success(Date.new(2019, 7, 13)) }

        it { is_expected.to eq 'Matched date success: 2019-07-13' }
      end

      context 'success time' do
        let(:result) { Dry::Monads::Success(Time.new(2019, 7, 13)) }

        it { is_expected.to eq 'Matched date success: 2019-07-13' }
      end
    end
  end
end
