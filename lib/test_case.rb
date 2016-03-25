require_relative 'test_case_description'
require_relative 'machine'
require_relative 'tape'
require_relative 'rejected_error'
require_relative 'machine_cycles_per_execution_exceeded'

class TestCase
  def initialize(description)
    @description = TestCaseDescription.parse(description)
  end

  def passes_for?(program, resources)
    machine = Machine.new(@description.input, program, resources)
    begin
      result = machine.execute
      used_cycles_for_execution = result[:used_cycles_for_execution]
      result_tape = result[:tape]
    rescue RejectedError, SyntaxError, MachineCyclesPerExecutionExceeded
      return {:is_ok => false, :used_machine_cycles => resources.machine_cycles_per_execution}
    end
    {:is_ok => result_tape == @description.expected_output, :used_machine_cycles => used_cycles_for_execution}
  end

  def input
    @description.input
  end

  def expected_output
    @description.expected_output
  end
end