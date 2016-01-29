require_relative 'test_case_description'
require_relative 'machine'
require_relative 'tape'
require_relative 'rejected_error'

class TestCase
  def initialize(description)
    @description = TestCaseDescription.parse(description)
  end

  def passes_for?(program, resources)
    machine = Machine.new(@description.input, program, resources)
    begin
      result_tape = machine.execute
    rescue RejectedError, SyntaxError, SystemStackError
      return false
    end
    result_tape == @description.expected_output
  end

  def input
    @description.input
  end

  def expected_output
    @description.expected_output
  end
end