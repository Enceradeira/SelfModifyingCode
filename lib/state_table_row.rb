class StateTableRow
  attr_reader :state_input
  attr_reader :transition

  def initialize(state_input, transition)
    @state_input = state_input
    @transition = transition
  end
end