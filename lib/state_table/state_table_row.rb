class StateTableRow
  attr_reader :state_input
  attr_reader :transition

  private
  def initialize(state_input, transition)
    @state_input = state_input
    @transition = transition
  end

  public
  def ==(other)
    @state_input==other.state_input && @transition==other.transition
  end
  alias_method :eql?, :==
end