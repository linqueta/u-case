require 'test_helper'

class Micro::Case::Strict::SafeTest < Minitest::Test
  class Multiply < Micro::Case::Strict::Safe
    attributes :a, :b

    def call!
      if a.is_a?(Numeric) && b.is_a?(Numeric)
        Success(a * b)
      else
        Failure(:invalid_data)
      end
    end
  end

  class Double < Micro::Case::Strict::Safe
    attributes :number

    def call!
      return Failure { 'number must be greater than 0' } if number <= 0

      Multiply.call(a: number, b: number)
    end
  end

  def test_instance_call_method
    result = Multiply.new(a: 2, b: 2).call

    assert_success_result(result, value: 4)

    result = Multiply.new(a: 1, b: '1').call

    assert_failure_result(result, value: :invalid_data, type: :invalid_data)
  end

  def test_class_call_method
    result = Double.call(number: 2)

    assert_success_result(result, value: 4)

    result = Double.call(number: 0)

    assert_failure_result(result, value: 'number must be greater than 0', type: :error)
  end

  class Foo < Micro::Case::Strict::Safe
  end

  def test_template_method
    assert_raises(NotImplementedError) { Micro::Case::Strict::Safe.call }
    assert_raises(NotImplementedError) { Micro::Case::Strict::Safe.new({}).call }

    assert_raises(NotImplementedError) { Foo.call }
    assert_raises(NotImplementedError) { Foo.new({}).call }
  end

  class LoremIpsum < Micro::Case::Strict::Safe
    attributes :text

    def call!
      text
    end
  end

  def test_result_error
    assert_raises_with_message(
      Micro::Case::Error::UnexpectedResult,
      /LoremIpsum#call! must return an instance of Micro::Case::Result/
    ) { LoremIpsum.call(text: 'lorem ipsum') }

    assert_raises_with_message(
      Micro::Case::Error::UnexpectedResult,
      /LoremIpsum#call! must return an instance of Micro::Case::Result/
    ) { LoremIpsum.new(text: 'ipsum indolor').call }
  end

  def test_keywords_validation
    assert_raises_with_message(ArgumentError, 'missing keywords: :a, :b') { Multiply.call({}) }

    assert_raises_with_message(ArgumentError, 'missing keyword: :b') { Multiply.call({a: 1}) }

    assert_raises_with_message(ArgumentError, 'missing keyword: :number') { Double.call(a: 1) }
  end

  class Divide < Micro::Case::Strict::Safe
    attributes :a, :b

    def call!
      if a.is_a?(Integer) && b.is_a?(Integer)
        Success(a / b)
      else
        Failure(:not_an_integer)
      end
    end
  end

  def test_that_exceptions_generate_a_failure
    result_1 = Divide.new(a: 2, b: 0).call

    assert_exception_result(result_1, value: ZeroDivisionError)

    # ---

    result_2 = Divide.call(a: 2, b: 0)

    assert_exception_result(result_2, value: ZeroDivisionError)
  end

  def test_to_proc
    results = [
      {a: 1, b: 2},
      {a: 2, b: 2},
      {a: 3, b: 2},
      {a: 4, b: 2}
    ].map(&Multiply)

    values = results.map(&:value)

    assert_equal([2, 4, 6, 8], values)
  end
end
