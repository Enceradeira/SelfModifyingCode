require_relative '../../lib/constants'

class Vocabulary
  private
  def initialize(states, symbols)
    if symbols.any? { |s| s == UNDEFINED }
      raise StandardError.new 'invalid symbol'
    end
    if states.any? { |s| s == UNDEFINED }
      raise StandardError.new 'invalid state'
    end
    @symbols_on_input = symbols
    @symbols_on_output = Array.new(symbols).concat([nil]).uniq
    @states_on_input = Array.new(states).concat([INIT_STATE]).uniq
    @states_on_output = Array.new(states).concat([ACCEPT_STATE]).uniq
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
  def get_state_on_input(excluded_state=UNDEFINED)
    choose_one_from(@states_on_input, excluded_state)
  end

  def get_symbol_on_input(excluded_symbol=UNDEFINED)
    choose_one_from(@symbols_on_input, excluded_symbol)
  end

  def get_state_on_output(excluded_state=UNDEFINED)
    choose_one_from(@states_on_output, excluded_state)
  end

  def get_symbol_on_output(excluded_symbol=UNDEFINED)
    choose_one_from(@symbols_on_output, excluded_symbol)
  end

  def get_direction(excluded_direction=UNDEFINED)
    choose_one_from(DIRECTIONS, excluded_direction)
  end
end