require_relative 'transition'

class Program
  private
  def initialize(source)
    nk = '[^->]' # all but keywords
    transitions = source.map do |t|
      r = Regexp.new("(#{nk}*),(#{nk}*)->(#{nk}*),([r,l,-]{1}),(#{nk}*)").match(t)
      direction_str = r[4]
      if direction_str == '-'
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
  end

  def build_key(state, input)
    "#{state};#{input}".to_sym
  end

  public
  def get_transition(state, input)
    key = build_key(state, input)
    @table[key]
  end
end