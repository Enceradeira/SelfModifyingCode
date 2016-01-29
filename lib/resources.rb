require_relative 'resource_exceeded_error'
require_relative 'constants'
require_relative 'machine_cycles'
require_relative 'machine_cycle'

class Resources
  attr_accessor :machine_cycles
  attr_accessor :machine_cycles_per_execution

  def initialize
    @machine_cycles = 1000
    @machine_cycles_per_execution = @machine_cycles / 10
    yield self if block_given?
    @machine_cycles_obj = MachineCycle.new(@machine_cycles)
  end

  def allocate_machine_cycle
    if @machine_cycles == UNLIMITED_MACHINE_CYCLES
      return
    end
    raise ResourceExceededError.new unless @machine_cycles > 0
    @machine_cycles = @machine_cycles - 1
  end

  def create_machine_cycles
    MachineCycles.new(@machine_cycles_obj,MachineCycle.new(machine_cycles_per_execution))
  end
end