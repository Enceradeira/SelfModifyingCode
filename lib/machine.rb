require_relative 'rejected_error'
require_relative 'head'
require_relative 'program'

class Machine
  def initialize(tape,source,initial_state,accept_state)
    @head = tape.create_head
    @program = Program.new(source)
    @state = initial_state
    @accept_state = accept_state
  end
  def execute
    value = @head.read
    transition = @program.get_transition(@state,value)
    if transition.nil?
      raise RejectedError.new
    end
    @head.write(transition.new_symbol)
    @head.move(transition.direction)
    @state = transition.new_state
    unless @state == @accept_state
      execute
    end
  end
end