require "dry/monads/result"
require "dry/monads/do"
require "dry/matcher/result_matcher"

RSpec.describe "Integration with dry-monads Do notation" do
  shared_examples "class using both dry-matcher and dry-monads Do notation" do
    it "supports yielding via Do notation as well as final result matching block" do
      matched_success = nil
      matched_failure = nil

      operation.(name: "Jane", email: "jane@example.com") do |m|
        m.success { |v| matched_success = v }
        m.failure { }
      end

      operation.(name: "Jo") do |m|
        m.success { }
        m.failure { |v| matched_failure = v }
      end

      expect(matched_success).to eq "Hello, Jane"
      expect(matched_failure).to eq :no_email
    end
  end

  describe "yielding" do
    let(:operation) {
      Class.new do
        include Dry::Monads::Result::Mixin
        include Dry::Monads::Do
        include Dry::Matcher.for(:call, with: Dry::Matcher::ResultMatcher)

        def call(user)
          user = yield validate(user)
          greeting = yield greet(user)

          Success(greeting)
        end

        private

        def validate(user)
          user[:email] ? Success(user) : Failure(:no_email)
        end

        def greet(user)
          Success("Hello, #{user[:name]}")
        end
      end.new
    }

    it_behaves_like "class using both dry-matcher and dry-monads Do notation"
  end

  describe "calling bind block explicitly" do
    let(:operation) {
      Class.new do
        include Dry::Monads::Result::Mixin
        include Dry::Monads::Do
        include Dry::Matcher.for(:call, with: Dry::Matcher::ResultMatcher)

        def call(user, &bind)
          user = bind.(validate(user))
          greeting = bind.(greet(user))

          Success(greeting)
        end

        private

        def validate(user)
          user[:email] ? Success(user) : Failure(:no_email)
        end

        def greet(user)
          Success("Hello, #{user[:name]}")
        end
      end.new
    }

    it_behaves_like "class using both dry-matcher and dry-monads Do notation"
  end
end

