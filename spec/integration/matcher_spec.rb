require "dry-monads"

RSpec.describe Dry::Matcher do
  context "with match cases provided" do
    let(:success_case) {
      Dry::Matcher::Case.new(
        match: -> result { result.right? },
        resolve: -> result { result.value },
      )
    }

    let(:failure_case) {
      Dry::Matcher::Case.new(
        match: -> result { result.left? },
        resolve: -> result { result.value },
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
      input = Dry::Monads::Right("Yes!")
      expect(call_match(input)).to eq "Success: Yes!"
    end

    it "matches on failure" do
      input = Dry::Monads::Left("No!")
      expect(call_match(input)).to eq "Failure: No!"
    end

    it "requires an exhaustive match" do
      input = Dry::Monads::Right("Yes!")

      expect {
        matcher.(input) do |m|
          m.success { |v| "Success: #{v}" }
        end
      }.to raise_error Dry::Matcher::NonExhaustiveMatchError
    end

    context "with wildcard handler" do
      let(:one_case) {
        Dry::Matcher::Case.new(match: -> result { result == 1 })
      }

      let(:two_case) {
        Dry::Matcher::Case.new(match: -> result { result == 2 })
      }

      let(:three_case) {
        Dry::Matcher::Case.new(match: -> result { result == 3 })
      }

      let(:matcher) {
        Dry::Matcher.new(
          one: one_case,
          two: two_case,
          three: three_case,
        )
      }

      def call_match(input)
        matcher.(input) do |m|
          m.one do |v|
            "One: #{1}"
          end

          m.else do |v|
            "Two or Three: #{v}"
          end
        end
      end

      it "matches on one" do
        expect(call_match(1)).to eq "One: 1"
      end

      it "matches on two" do
        expect(call_match(2)).to eq "Two or Three: 2"
      end

      it "matches on three" do
        expect(call_match(3)).to eq "Two or Three: 3"
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
