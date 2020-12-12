# frozen_string_literal: true

require "date"
require "dry/monads"
require "dry/matcher/result_matcher"

RSpec.describe "Dry::Matcher::ResultMatcher" do
  extend Dry::Monads[:result, :try]
  include Dry::Monads[:result, :try]

  before { Object.send(:remove_const, :Operation) if defined? Operation }

  def self.set_up_expectations(matches)
    matches.each do |value, matched|
      context "Matching #{value}" do
        let(:result) { value }

        it { is_expected.to eql(matched) }
      end
    end
  end

  describe "external matching" do
    subject do
      Dry::Matcher::ResultMatcher.(result) do |m|
        m.success do |v|
          "Matched success: #{v}"
        end

        m.failure do |v|
          "Matched failure: #{v}"
        end
      end
    end

    set_up_expectations(
      Success("a success") => "Matched success: a success",
      Failure("a failure") => "Matched failure: a failure",
      Try(StandardError) { "a success" } => "Matched success: a success",
      Try(StandardError) { raise("a failure") } => "Matched failure: a failure"
    )
  end

  context "multiple branch matching" do
    subject do
      Dry::Matcher::ResultMatcher.(result) do |on|
        on.success(:a) { "Matched specific success: :a" }
        on.success(:b) { "Matched specific success: :b" }
        on.success { |v| "Matched general success: #{v}" }
        on.failure(:a) { "Matched specific failure: :a" }
        on.failure(:b) { "Matched specific failure: :b" }
        on.failure { |v| "Matched general failure: #{v}" }
      end
    end

    set_up_expectations(
      Success(:a) => "Matched specific success: :a",
      Success(:b) => "Matched specific success: :b",
      Success("a success") => "Matched general success: a success",
      Failure(:a) => "Matched specific failure: :a",
      Failure(:b) => "Matched specific failure: :b",
      Failure("a failure") => "Matched general failure: a failure"
    )
  end

  context "using ===" do
    subject do
      Dry::Matcher::ResultMatcher.(result) do |on|
        on.success(/done/) { |s| "Matched string by pattern: #{s.inspect}" }
        on.success(String) { |s| "Matched string success: #{s.inspect}" }
        on.success(Integer) { |n| "Matched integer success: #{n}" }
        on.success(Date, Time) { |t| "Matched date success: #{t.strftime('%Y-%m-%d')}" }
        on.success { |v| "Matched general success: #{v}" }
        on.failure(Integer) { |n| "Matched integer failure: #{n}" }
        on.failure { |v| "Matched general failure: #{v}" }
      end
    end

    set_up_expectations(
      Success("nicely done") => 'Matched string by pattern: "nicely done"',
      Success("yay") => 'Matched string success: "yay"',
      Success(3) => "Matched integer success: 3",
      Failure(3) => "Matched integer failure: 3",
      Success(Date.new(2019, 7, 13)) => "Matched date success: 2019-07-13",
      Success(Time.new(2019, 7, 13)) => "Matched date success: 2019-07-13"
    )
  end

  context "matching tuples using codes" do
    subject do
      Dry::Matcher::ResultMatcher.(result) do |on|
        on.success(:created) { |code, s| "Matched #{code.inspect} by code: #{s.inspect}" }
        on.success(:updated) { |_, s, v| "Matched :updated by code: #{s.inspect}, #{v.inspect}" }
        on.success(:deleted) { |_, s| "Matched :deleted by code: #{s.inspect}" }
        on.success(Symbol) { |sym, s| "Matched #{sym.inspect} by Symbol: #{s.inspect}" }
        on.success(200...300) { |status, _, body| "Matched #{status} body: #{body}" }
        on.success { |v| "Matched general success: #{v.inspect}" }
        on.failure(:not_found) { |_, e| "Matched not found with #{e.inspect}" }
        on.failure("not_found") { |e| "Matched not found by string: #{e.inspect}" }
        on.failure { |v| "Matched general failure: #{v.inspect}" }
      end
    end

    set_up_expectations(
      Success([:created, 5]) => "Matched :created by code: 5",
      Success([:updated, 6, 7]) => "Matched :updated by code: 6, 7",
      Success([:deleted, 8, 9]) => "Matched :deleted by code: 8",
      Success([:else, 10, 11]) => "Matched :else by Symbol: 10",
      Success([201, {}, "done!"]) => "Matched 201 body: done!",
      Success(["complete"]) => 'Matched general success: ["complete"]',
      Failure(%i[not_found for_a_reason]) => "Matched not found with :for_a_reason",
      Failure(:other) => "Matched general failure: :other"
    )
  end

  context "with .for" do
    let(:operation) do
      class Operation
        include Dry::Matcher::ResultMatcher.for(:perform)

        def perform(value)
          value
        end
      end
      Operation.new
    end

    context "using with methods" do
      def match(value)
        operation.perform(value) do |m|
          m.success { |v| "success: #{v}" }
          m.failure { |e| "failure: #{e}" }
        end
      end

      it "builds a wrapping module" do
        expect(match(Success(:foo))).to eql("success: foo")
        expect(match(Failure(:bar))).to eql("failure: bar")
      end
    end

    context "with keyword arguments" do
      let(:operation) do
        class Operation
          include Dry::Matcher::ResultMatcher.for(:perform)

          def perform(value:)
            value
          end
        end
        Operation.new
      end

      it "works without a warning" do
        result = operation.perform(value: Success(1)) do |m|
          m.success { |v| v }
          m.failure { raise }
        end

        expect(result).to be(1)
      end
    end
  end
end
