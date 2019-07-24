RSpec.describe Dry::Matcher::Case do
  let(:undefined) { Dry::Core::Constants::Undefined }

  describe 'old interface' do
    describe 'matching' do
      subject(:kase) { described_class.new(match: -> value { value.even? }) }

      it "calls the match proc with the value" do
        expect(kase.(2) { :matched }).to be(:matched)
        expect(kase.(1) { fail }).to be(undefined)
      end
    end

    describe 'resolving' do
      it "calls the resolve proc with the value" do
        kase = described_class.new(match: -> * { true }, resolve: -> value { value.to_s })

        expect(kase.(123) { |result| result }).to eq "123"
      end

      it "defaults to passing through the value" do
        kase = described_class.new(match: -> * { true })
        expect(kase.(123) { |result| result }).to eq 123
      end
    end
  end

  describe '#call' do
    describe 'using patterns' do
      let(:kase) do
        described_class.new do |value, patterns|
          if patterns.include?(value)
            value
          else
            undefined
          end
        end
      end

      it 'uses patterns to match given value' do
        expect(kase.(3, [1, 2, 3]) { |value| value.to_s }).to eql('3')
        expect(kase.(4, [1, 2, 3]) { fail }).to be(undefined)
      end
    end

    describe 'extracting values' do
      let(:kase) do
        described_class.new do |(code, value), patterns|
          if patterns.include?(code)
            value
          else
            undefined
          end
        end
      end

      it 'transforms value by dropping result code' do
        expect(kase.([:found, 100], [:found, :not_found]) { |value| value.to_s }).to eql('100')
        expect(kase.([:else, 100], [:found, :not_found]) { fail }).to be(undefined)
      end
    end
  end
end
