class StateTableRow  < Struct.new(:state_input, :transition)
  private
  def initialize(state_input, transition)
    self.state_input = state_input
    self.transition = transition
  end

end