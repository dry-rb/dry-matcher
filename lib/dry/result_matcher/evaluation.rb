module Dry
  module ResultMatcher
    class Evaluation
      attr_reader :result
      attr_reader :output

      def initialize(result, cases)
        @result = result
        @output = nil
        @matched = false

        cases.each do |name, kase|
          define_singleton_method(name) do |pattern = nil, &block|
            handle_case(kase, pattern, &block)
          end
        end
      end

      def call(&block)
        block.call(self)
        output
      end

      private

      def handle_case(kase, pattern, &block)
        return(output) if matched?

        if kase.match?(pattern, result)
          @matched = true

          value = kase.resolve(result)
          @output = block.call(value)
          @output
        end
      end

      def matched?
        !!@matched
      end
    end
  end
end
