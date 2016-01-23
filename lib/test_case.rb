require_relative 'test_case_description'
require_relative 'machine'
require_relative 'tape'
require_relative 'rejected_error'

class TestCase
  def initialize(description)
    @description = TestCaseDescription.parse(description)
  end

  def passes_for?(program)
    machine = Machine.new(@description.input, program)
    begin
      result_tape = machine.execute
    rescue RejectedError
      return false
    end
    result_tape == @description.expected_output
  end
end