require_relative '../../lib/constants'

class Vocabulary
  private
  def initialize(states, symbols)
    @symbols = symbols
    @states = Array.new(states).concat([INIT_STATE]).uniq
  end

  def choose_one_from(enum, excluded_element)
    if enum.count == 1
      elements_to_choose_from = enum
    else
      elements_to_choose_from = enum.select { |s| s != excluded_element }
    end
    elements_to_choose_from.sample
  end

  public
  def get_state_randomly(excluded_state=nil)
    choose_one_from(@states, excluded_state)
  end

  def get_symbol_randomly(excluded_symbol =nil)
    choose_one_from(@symbols, excluded_symbol)
  end
end