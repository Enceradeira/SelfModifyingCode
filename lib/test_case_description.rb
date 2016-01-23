class TestCaseDescription < Struct.new(:input, :expected_output)
  class << self
    def parse(string)
      sym = '[^->,]' # all but keywords
      tape = "(#{sym}+(?:,#{sym}+)*)?"
      expr = "^#{tape}->#{tape}$"
      result = Regexp.new(expr).match(string)
      if result.nil?
        raise StandardError.new('testcase description is invalid')
      end

      input_as_str = result[1]
      output_as_str = result[2]

      if input_as_str.nil?
        input = []
      else
        input = input_as_str.split(',')
      end

      if output_as_str.nil?
        expected_output = []
      else
        expected_output = output_as_str.split(',')
      end
      TestCaseDescription.new(input, expected_output)
    end
  end
end
