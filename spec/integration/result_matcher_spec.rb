require 'date'
require "dry/monads"
require "dry/matcher/result_matcher"

RSpec.describe "Dry::Matcher::ResultMatcher" do
  extend Dry::Monads[:result, :try]
  include Dry::Monads[:result, :try]

  def self.set_up_expectations(matches)
    matches.each do |value, matched|
      context "Matching #{value}" do
        let(:result) { value }

        it { is_expected.to eql(matched) }
      end
    end
  end

  describe "external matching" do
    subject {
      Dry::Matcher::ResultMatcher.(result) do |m|
        m.success do |v|
          "Matched success: #{v}"
        end

        m.failure do |v|
          "Matched failure: #{v}"
        end
      end
    }

    set_up_expectations(
      Success("a success") => "Matched success: a success",
      Failure("a failure") => "Matched failure: a failure",
      Try(StandardError) { 'a success' } => "Matched success: a success",
      Try(StandardError) { raise('a failure') } => "Matched failure: a failure"
    )
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

    set_up_expectations(
      Success(:a) => 'Matched specific success: :a',
      Success(:b) => 'Matched specific success: :b',
      Success('a success') => 'Matched general success: a success',
      Failure(:a) => 'Matched specific failure: :a',
      Failure(:b) => 'Matched specific failure: :b',
      Failure('a failure') => 'Matched general failure: a failure'
    )
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

    set_up_expectations(
      Success('nicely done') => 'Matched string by pattern: "nicely done"',
      Success('yay') => 'Matched string success: "yay"',
      Success(3) => 'Matched integer success: 3',
      Failure(3) => 'Matched integer failure: 3',
      Success(Date.new(2019, 7, 13)) => 'Matched date success: 2019-07-13',
      Success(Time.new(2019, 7, 13)) => 'Matched date success: 2019-07-13',
    )
  end
end
