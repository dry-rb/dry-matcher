# frozen_string_literal: true

require "date"
require "dry/monads"
require "dry/matcher/maybe_matcher"

RSpec.describe "Dry::Matcher::MaybeMatcher" do
  extend Dry::Monads[:maybe]
  include Dry::Monads[:maybe]

  before { Object.send(:remove_const, :Operation) if defined? Operation }

  def self.prepare_expectations(matches)
    matches.each do |value, matched|
      context "Matching #{value}" do
        let(:result) { value }

        it { is_expected.to eql(matched) }
      end
    end
  end

  describe "external matching" do
    subject do
      Dry::Matcher::MaybeMatcher.(result) do |m|
        m.some do |v|
          "Matched some: #{v}"
        end

        m.none do
          "Matched none"
        end
      end
    end

    prepare_expectations(
      Some("a success") => "Matched some: a success",
      None() => "Matched none"
    )
  end

  context "multiple branch matching" do
    subject do
      Dry::Matcher::MaybeMatcher.(result) do |on|
        on.some(:a) { "Matched specific success: :a" }
        on.some(:b) { "Matched specific success: :b" }
        on.some { |v| "Matched general success: #{v}" }
        on.none { "Matched none" }
      end
    end

    prepare_expectations(
      Some(:a) => "Matched specific success: :a",
      Some(:b) => "Matched specific success: :b",
      Some("a success") => "Matched general success: a success",
      None() => "Matched none"
    )
  end

  context "using ===" do
    subject do
      Dry::Matcher::MaybeMatcher.(result) do |on|
        on.some(/done/) { |s| "Matched string by pattern: #{s.inspect}" }
        on.some(String) { |s| "Matched string success: #{s.inspect}" }
        on.some(Integer) { |n| "Matched integer success: #{n}" }
        on.some(Date, Time) { |t| "Matched date success: #{t.strftime("%Y-%m-%d")}" }
        on.some { |v| "Matched general success: #{v}" }
        on.none { "Matched none" }
      end
    end

    prepare_expectations(
      Some("nicely done") => 'Matched string by pattern: "nicely done"',
      Some("yay") => 'Matched string success: "yay"',
      Some(3) => "Matched integer success: 3",
      Some(Date.new(2019, 7, 13)) => "Matched date success: 2019-07-13",
      Some(Time.new(2019, 7, 13)) => "Matched date success: 2019-07-13",
      None() => "Matched none"
    )
  end

  context "matching tuples using codes" do
    subject do
      Dry::Matcher::MaybeMatcher.(result) do |on|
        on.some(:created) { |code, s| "Matched #{code.inspect} by code: #{s.inspect}" }
        on.some(:updated) { |_, s, v| "Matched :updated by code: #{s.inspect}, #{v.inspect}" }
        on.some(:deleted) { |_, s| "Matched :deleted by code: #{s.inspect}" }
        on.some(Symbol) { |sym, s| "Matched #{sym.inspect} by Symbol: #{s.inspect}" }
        on.some(200...300) { |status, _, body| "Matched #{status} body: #{body}" }
        on.some { |v| "Matched general success: #{v.inspect}" }
        on.none { "Matched none" }
      end
    end

    prepare_expectations(
      Some([:created, 5]) => "Matched :created by code: 5",
      Some([:updated, 6, 7]) => "Matched :updated by code: 6, 7",
      Some([:deleted, 8, 9]) => "Matched :deleted by code: 8",
      Some([:else, 10, 11]) => "Matched :else by Symbol: 10",
      Some([201, {}, "done!"]) => "Matched 201 body: done!",
      Some(["complete"]) => 'Matched general success: ["complete"]',
      None() => "Matched none"
    )
  end

  context "with .for" do
    let(:operation) do
      class Operation
        include Dry::Matcher::MaybeMatcher.for(:perform)

        def perform(value)
          value
        end
      end
      Operation.new
    end

    context "using with methods" do
      def match(value)
        operation.perform(value) do |m|
          m.some { |v| "success: #{v}" }
          m.none { "none" }
        end
      end

      it "builds a wrapping module" do
        expect(match(Some(:foo))).to eql("success: foo")
        expect(match(None())).to eql("none")
      end
    end

    context "with keyword arguments" do
      let(:operation) do
        class Operation
          include Dry::Matcher::MaybeMatcher.for(:perform)

          def perform(value:)
            value
          end
        end
        Operation.new
      end

      it "works without a warning" do
        result = operation.perform(value: Some(1)) do |m|
          m.some { |v| v }
          m.none { raise }
        end

        expect(result).to be(1)
      end
    end
  end
end
