require_relative 'resource_exceeded_error'
require_relative 'machine_cycles_per_execution_exceeded'

class MachineCycles
  def initialize(cycles, cycles_per_execution)
    @cycles = cycles
    @cycles_per_execution = cycles_per_execution
  end

  def allocate_one
    @cycles.allocate_one
    begin
      @cycles_per_execution.allocate_one
    rescue ResourceExceededError
      raise MachineCyclesPerExecutionExceeded.new
    end
  end
end