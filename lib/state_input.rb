class StateInput
  attr_reader :state
  attr_reader :symbol

  def initialize(state, symbol)
    @state = state
    @symbol = symbol
  end
end