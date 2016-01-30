require_relative 'resource_exceeded_error'
require_relative 'constants'

class MachineCycle
  attr_reader :cycles

  def initialize(cycles)
    @cycles = cycles
  end

  def allocate_one
    if @cycles == UNLIMITED_MACHINE_CYCLES
      return
    end
    raise ResourceExceededError.new unless @cycles > 0
    @cycles = @cycles - 1
  end
end