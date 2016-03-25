require_relative 'rejected_error'
require_relative 'head'
require_relative 'program'
require_relative 'tape'
require_relative 'constants'

class Machine
  def initialize(tape_content, program, resources)
    @resources = resources
    @tape = Tape.new(tape_content)
    @head = @tape.create_head
    @program = program
    @state = INIT_STATE
  end

  private
  def execute_cycle(cycles)
    cycles.allocate_one

    value = @head.read
    if value.nil?
      # tape finished
      @state = ACCEPT_STATE
    else
      transition = @program.get_transition(@state, value)
      if transition.nil?
        raise RejectedError.new
      end
      @head.write(transition.new_symbol)
      @head.move(transition.direction)
      @state = transition.new_state
    end
  end

  public
  def execute
    cycles = @resources.create_machine_cycles

    while @state != ACCEPT_STATE
      execute_cycle(cycles)
    end
    {:tape => @tape.to_a, :used_cycles_for_execution => cycles.used_cycles_for_execution}
  end

  class << self
    def execute(tape_content, source, resources)
      Machine.new(tape_content, Program.compile(source), resources).execute
    end
  end

end