require_relative 'transition'

class Program
  private
  def initialize(source)
    nk = '[^->,]' # all but keywords
    transitions = source.map do |t|
      r = Regexp.new("(#{nk}*),(#{nk}*)->(#{nk}*),([rl]?),(#{nk}*)").match(t)
      if r.nil?
        raise StandardError.new "invalid program: #{t}"
      end
      direction_str = r[4]
      if direction_str.empty?
        direction = nil
      else
        direction = direction_str.to_sym
      end
      new_symbol_str = r[3]
      if new_symbol_str.empty?
        new_symbol = nil
      else
        new_symbol = new_symbol_str
      end

      [build_key(r[1], r[2]), Transition.new(new_symbol, direction, r[5])]
    end
    @table = Hash[transitions]
    @source = source
  end

  def build_key(state, input)
    "#{state};#{input}".to_sym
  end

  public
  def get_transition(state, input)
    exact_match = @table[build_key(state, input)]
    any_state_match = @table[build_key('', input)]
    any_input_match = @table[build_key(state, '')]
    any_input_any_state_match = @table[build_key('', '')]

    nr = 0
    result = nil
    unless exact_match.nil?
      nr = nr +1
      result =exact_match
    end
    unless any_state_match.nil?
      nr = nr +1
      result =any_state_match
    end
    unless any_input_match.nil?
      nr = nr +1
      result =any_input_match
    end
    unless any_input_any_state_match.nil?
      nr = nr +1
      result =any_input_any_state_match
    end

    if nr > 1
      raise StandardError.new 'table is ambiguous'
    end

    result
  end

  def to_source
    @source
  end
end