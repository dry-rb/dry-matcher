require "dry-monads"

RSpec.describe Dry::Matcher do
  context "with match cases provided" do
    let(:success_case) {
      Dry::Matcher::Case.new(
        match: -> result { result.success? },
        resolve: -> result { result.value! },
      )
    }

    let(:failure_case) {
      Dry::Matcher::Case.new(
        match: -> result { result.failure? },
        resolve: -> result { result.failure },
      )
    }

    let(:matcher) {
      Dry::Matcher.new(
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
      input = Dry::Monads::Success("Yes!")
      expect(call_match(input)).to eq "Success: Yes!"
    end

    it "matches on failure" do
      input = Dry::Monads::Failure("No!")
      expect(call_match(input)).to eq "Failure: No!"
    end

    it "requires an exhaustive match" do
      input = Dry::Monads::Success("Yes!")

      expect {
        matcher.(input) do |m|
          m.success { |v| "Success: #{v}" }
        end
      }.to raise_error Dry::Matcher::NonExhaustiveMatchError
    end

    context "with wildcard handler" do
      let(:less_case) {
        Dry::Matcher::Case.new(match: -> result { result < 0 })
      }

      let(:zero_case) {
        Dry::Matcher::Case.new(match: -> result { result == 0 })
      }

      let(:one_case) {
        Dry::Matcher::Case.new(match: -> result { result == 1 })
      }

      let(:greater_case) {
        Dry::Matcher::Case.new(match: -> result { result > 1 })
      }

      let(:matcher) {
        Dry::Matcher.new(
          less: less_case,
          zero: zero_case,
          one: one_case,
          greater: greater_case
        )
      }

      def call_match(input)
        matcher.(input) do |m|
          m.less do |v|
            "Less: #{v}"
          end

          m.else do |v|
            "Zero or One: #{v}"
          end

          m.greater do |v|
            "Greater: #{v}"
          end
        end
      end

      it "matches on -1" do
        expect(call_match(-1)).to eq "Less: -1"
      end

      it "matches on 0" do
        expect(call_match(0)).to eq "Zero or One: 0"
      end

      it "matches on 1" do
        expect(call_match(1)).to eq "Zero or One: 1"
      end

      it "matches on 2" do
        expect(call_match(2)).to eq "Greater: 2"
      end
    end

    context "with patterns" do
      let(:success_case) {
        Dry::Matcher::Case.new(
          match: -> result { result.first == :ok },
          resolve: -> result { result.last },
        )
      }

      let(:failure_case) {
        Dry::Matcher::Case.new(
          match: -> result, failure_type {
            result.length == 3 && result[0] == :failure && result[1] == failure_type
          },
          resolve: -> result { result.last },
        )
      }

      def call_match(input)
        matcher.(input) do |m|
          m.success

          m.failure :my_error do |v|
            "Pattern-matched failure: #{v}"
          end
        end
      end

      it "matches using the provided pattern" do
        input = [:failure, :my_error, "No!"]
        expect(call_match(input)).to eq "Pattern-matched failure: No!"
      end

      it "doesn't match if the pattern doesn't match" do
        input = [:failure, :non_matching_error, "No!"]
        expect(call_match(input)).to be_nil
      end
    end
  end
end
