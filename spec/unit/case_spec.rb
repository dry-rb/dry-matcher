RSpec.describe Dry::Matcher::Case do
  describe "#matches?" do
    it "calls the match proc with the value" do
      kase = described_class.new(match: -> value { value.even? })
      expect(kase.matches?(2)).to be true
      expect(kase.matches?(1)).to be false
    end
  end

  describe "#resolve" do
    it "calls the resolve proc with the value" do
      kase = described_class.new(match: -> * { true }, resolve: -> value { value.to_s })

      expect(kase.resolve(123)).to eq "123"
    end

    it "defaults to passing through the value" do
      kase = described_class.new(match: -> * { true })
      expect(kase.resolve(123)).to eq 123
    end
  end
end
