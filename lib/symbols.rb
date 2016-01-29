class Symbols
  attr_reader :for_input
  attr_reader :for_output

  def initialize(test_cases)
    @for_input = (test_cases.map { |c| c.input }.flatten + [nil]).uniq
    @for_output = (test_cases.map { |c| c.expected_output }.flatten+[nil]).uniq
  end


end