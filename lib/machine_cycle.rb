require_relative 'resource_exceeded_error'
require_relative 'constants'

class MachineCycle
  private
  def initialize(cycles)
    @total_cycles = cycles
    @cycles = cycles
  end

  public

  attr_reader :cycles
  def allocate_one
    if @cycles == UNLIMITED_MACHINE_CYCLES
      return
    end
    unless @cycles > 0
      raise ResourceExceededError.new
    end
    @cycles = @cycles - 1
  end

  def used_machine_cycles
    @total_cycles - @cycles
  end
end