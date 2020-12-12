# frozen_string_literal: true

RSpec.describe Dry::Matcher::Case do
  let(:undefined) { Dry::Core::Constants::Undefined }

  describe "old interface" do
    describe "matching" do
      subject(:kase) { described_class.new(match: -> value { value.even? }) }

      it "calls the match proc with the value" do
        expect(kase.call(2) { :matched }).to be(:matched)
        expect(kase.call(1) { raise }).to be(undefined)
      end
    end

    describe "resolving" do
      it "calls the resolve proc with the value" do
        kase = described_class.new(match: -> * { true }, resolve: -> value { value.to_s })

        expect(kase.call(123) { |result| result }).to eq "123"
      end

      kase = described_class.new(match: -> * { true })
      it "defaults to passing through the value" do
        expect(kase.call(123) { |result| result }).to eq 123
      end
    end
  end

  describe "#call" do
    describe "using patterns" do
      let(:kase) do
        described_class.new do |value, patterns|
          if patterns.include?(value)
            value
          else
            undefined
          end
        end
      end

      it "uses patterns to match given value" do
        expect(kase.call(3, [1, 2, 3], &:to_s)).to eql("3")
        expect(kase.call(4, [1, 2, 3]) { raise }).to be(undefined)
      end
    end

    describe "extracting values" do
      let(:kase) do
        described_class.new do |(code, value), patterns|
          if patterns.include?(code)
            value
          else
            undefined
          end
        end
      end

      it "transforms value by dropping result code" do
        expect(kase.call([:found, 100], %i[found not_found], &:to_s)).to eql("100")
        expect(kase.call([:else, 100], %i[found not_found]) { raise }).to be(undefined)
      end
    end
  end
end
