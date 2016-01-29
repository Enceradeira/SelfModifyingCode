require_relative 'rejected_error'
require_relative 'head'
require_relative 'program'
require_relative 'tape'
require_relative 'constants'

class Machine
  class << self
    def execute(tape_content, source)
      Machine.new(tape_content, Program.compile(source)).execute
    end
  end

  def initialize(tape_content, program)
    @tape = Tape.new(tape_content)
    @head = @tape.create_head
    @program = program
    @state = INIT_STATE
  end

  def execute
    value = @head.read
    if value.nil?
      # tape finished
      return
    end
    transition = @program.get_transition(@state, value)
    if transition.nil?
      raise RejectedError.new
    end
    @head.write(transition.new_symbol)
    @head.move(transition.direction)
    @state = transition.new_state
    unless @state == ACCEPT_STATE
      execute
    end
    @tape.to_a
  end
end