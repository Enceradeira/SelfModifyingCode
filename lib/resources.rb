require_relative 'resource_exceeded_error'
require_relative 'constants'

class Resources
  attr_accessor :machine_cycles

  def initialize
    @machine_cycles = 1000
    yield self if block_given?
  end

  def consume_machine_cycle
    if @machine_cycles == UNLIMITED_MACHINE_CYCLES
      return
    end
    raise ResourceExceededError.new unless @machine_cycles > 0
    @machine_cycles = @machine_cycles - 1
  end
end