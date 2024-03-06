class StringCalculator
  def add_input(string_of_numbers)
    raise 'only accepts a string' unless string_of_numbers.is_a?(String)
    raise "Invalid input" if string_of_numbers.chomp("\n").end_with?(',')
    string_array = extract_delimiter(string_of_numbers) || string_of_numbers.split(/[^0-9-]+/)
    integer_array = string_array.map(&:to_i)
    raise "cannot accept negatives - #{extract_negatives(integer_array)}" if extract_negatives(integer_array)
    integer_array.inject(0){|sum,x| x <= 1000? sum + x : sum }
  end

  def extract_negatives(integer_array)
     negatives_array = integer_array.select{ |i| i<0 }
    if negatives_array.length > 0
      return negatives_string = negatives_array.join(",")
    else
      return false
    end
  end

  def extract_delimiter(numbers)
    # Check if custom delimiter is provided
    if numbers.start_with?("//")
      delimiter, numbers = numbers.split("\n", 2)
      delimiter = delimiter[2..-1] # Remove the "//" prefix
    else
      # Use default delimiter
      delimiter = ","
    end

    string_array = numbers.split(/#{delimiter}|\n/)
  end

end

calculator = StringCalculator.new
puts calculator.add_input("//;\n1;2") #3
puts calculator.add_input("1\n2,3") #6
puts calculator.add_input("") #0
# puts calculator.add_input("-1,\n") # invalid
# puts calculator.add_input("-1") # invalid -negative




class TestStringCalculator
  def initialize
    @calculator = StringCalculator.new
  end

  def run_tests
    test_accept_string
    test_reject_other_data_types
    test_return_zero_for_empty_string
    test_return_number_for_single_number
    test_return_sum_for_comma_delimiters
    test_return_sum_for_newline_delimiters
    test_handle_multiple_delimiters
    test_reject_negative_numbers
    test_ignore_numbers_larger_than_1000
  end

  private

  def assert_equal(expected, actual, message = nil)
    if expected == actual
      puts "PASS: #{message}"
    else
      puts "FAIL: #{message}. Expected #{expected}, but got #{actual}."
    end
  end

  def assert_raises_error(expected_error_message, message = nil, &block)
    begin
      block.call
      puts "FAIL: #{message}. Expected an error '#{expected_error_message}', but no error was raised."
    rescue StandardError => e
      if e.message == expected_error_message
        puts "PASS: #{message}"
      else
        puts "FAIL: #{message}. Expected an error '#{expected_error_message}', but got '#{e.message}'."
      end
    end
  end

  def test_accept_string
    assert_equal(nil, assert_raises_error('only accepts a string') { @calculator.add_input(123) }, "should accept a string")
    assert_equal(nil, assert_raises_error('only accepts a string') { @calculator.add_input(['123']) }, "should accept a string")
  end

  def test_reject_other_data_types
    assert_equal(nil, assert_raises_error('only accepts a string') { @calculator.add_input(123) }, "should not accept other data types")
    assert_equal(nil, assert_raises_error('only accepts a string') { @calculator.add_input(['123']) }, "should not accept other data types")
  end

  def test_return_zero_for_empty_string
    assert_equal(0, @calculator.add_input(''), "should return 0 for an empty string")
  end

  def test_return_number_for_single_number
    assert_equal(123, @calculator.add_input('123'), "should return a number if the passed string contains no delimiters")
  end

  def test_return_sum_for_comma_delimiters
    assert_equal(46, @calculator.add_input('12,34'), "should return the sum of the numbers in the passed string, if the passed string contains comma delimiters")
  end

  def test_return_sum_for_newline_delimiters
    assert_equal(102, @calculator.add_input("12\n34\n56"), "should return the sum of the numbers in the passed string, if the passed string contains new line delimiters")
  end

  def test_handle_multiple_delimiters
    assert_equal(3, @calculator.add_input("//;\n1;2"), "should handle multiple random delimiters")
  end

  def test_reject_negative_numbers
    assert_raises_error("cannot accept negatives - -2", "should not accept negative numbers") { @calculator.add_input("123,-2") }
  end
end

# Run the tests
TestStringCalculator.new.run_tests
