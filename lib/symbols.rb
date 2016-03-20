class Symbols
  attr_reader :for_input
  attr_reader :for_output

  def initialize(test_cases)
    input = test_cases.map { |c| c.input }.flatten.uniq
    output = test_cases.map { |c| c.expected_output }.flatten.uniq

    if input.empty?
      raise StandardError.new 'input is empty'
    end

    if output.empty?
      raise StandardError.new 'output is empty'
    end

    @for_input = input
    @for_output = output
  end


end