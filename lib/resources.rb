require_relative 'resource_exceeded_error'
require_relative 'constants'
require_relative 'machine_cycles'
require_relative 'machine_cycle'

class Resources
  attr_accessor :machine_cycles
  attr_accessor :machine_cycles_per_execution

  def initialize
    @total_nr_machine_executions = 0
    @machine_cycles = 1000
    @machine_cycles_per_execution = @machine_cycles / 10
    yield self if block_given?
    @machine_cycles_obj = MachineCycle.new(@machine_cycles)
  end

  def create_machine_cycles
    @total_nr_machine_executions = @total_nr_machine_executions + 1
    MachineCycles.new(@machine_cycles_obj, MachineCycle.new(machine_cycles_per_execution))
  end

  def create_statistic
    statistic = []
    statistic << "Total machine cycles:     #{total_machine_cycles}"
    statistic << "Total machine executions: #{@total_nr_machine_executions}"
    statistic.join("\n")
  end

  def total_machine_cycles
    @machine_cycles-@machine_cycles_obj.cycles
  end
end