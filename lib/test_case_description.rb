class TestCaseDescription < Struct.new(:input, :expected_output)
  class << self
    def parse(string)
      split = ' '
      sym = "[^->#{split}]" # all but keywords
      tape = "(#{sym}+(?:#{split}#{sym}+)*)?"
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
        input = input_as_str.split(split)
      end

      if output_as_str.nil?
        expected_output = []
      else
        expected_output = output_as_str.split(split)
      end
      TestCaseDescription.new(input.map { |s| s.to_sym }, expected_output.map { |s| s.to_sym })
    end
  end
end
