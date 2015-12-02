require "kleisli"

module EitherResultMatcher
  class Matcher
    attr_reader :result
    attr_reader :output

    def initialize(result)
      @result = result
    end

    def success(&block)
      return output unless result.is_a?(Kleisli::Either::Right)
      @output = block.call(result.value)
    end

    def failure(&block)
      return output unless result.is_a?(Kleisli::Either::Left)
      @output = block.call(result.value)
    end
  end
end
