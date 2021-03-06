require 'test_helper'

if ENV.fetch('ACTIVEMODEL_VERSION', '6.1') <= '6.0.0'

  module Micro::Case::WithValidation
    class BaseTest < Minitest::Test
      class Multiply < Micro::Case
        attribute :a
        attribute :b
        validates :a, :b, presence: true, numericality: true

        def call!
          Success(number: a * b)
        end
      end

      class NumberToString < Micro::Case
        attribute :number
        validates :number, presence: true, numericality: true

        def call!
          Success(number.to_s)
        end
      end

      def test_success
        calculation = Multiply.new(a: 2, b: 2).call

        assert_success_result(calculation, value: { number: 4 })

        # ---

        flow = Micro::Case::Flow([Multiply, NumberToString])

        assert_success_result(flow.call(a: 2, b: 2), value: '4')
      end

      def test_failure
        result = Multiply.new(a: 1, b: nil).call

        assert_failure_result(result, type: :validation_error)
        assert_equal(["can't be blank", 'is not a number'], result.value[:errors][:b])

        # ---

        result = Multiply.new(a: 1, b: 'a').call

        assert_failure_result(result, type: :validation_error)
        assert_equal(['is not a number'], result.value[:errors][:b])
      end
    end
  end

end
