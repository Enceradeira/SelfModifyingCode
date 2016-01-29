require_relative 'state_transition'
require_relative 'state_table'
require_relative 'state_table_row'
require_relative 'state_input'

class Program
  private
  def initialize(table)
    transitions = table.rows.map do |row|
      state_input = row.state_input
      transition = row.transition

      [build_key(state_input.state, state_input.symbol), transition]
    end
    @table = Hash[transitions]
  end

  def build_key(state, input)
    "#{state};#{input}".to_sym
  end


  class << self
    def to_sym_or_nil(string)
      unless string.nil?
        return string.to_sym
      end
      nil
    end
  end

  public
  class << self

    def compile(source)
      nk = '[^->,]' # all but keywords
      table = StateTable.new(source.map do |t|
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

        StateTableRow.new(StateInput.new(to_sym_or_nil(r[1]), to_sym_or_nil(r[2])), StateTransition.new(to_sym_or_nil(new_symbol), to_sym_or_nil(direction), to_sym_or_nil(r[5])))
      end)
      Program.new(table)
    end
  end

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
      raise SyntaxError.new 'table is ambiguous'
    end

    result
  end

  def to_source
    @table.map do |kv|
      state_input = kv[0].to_s().split(';')
      transition = kv[1]
      "#{state_input[0]},#{state_input[1]}->#{transition.new_symbol},#{transition.direction},#{transition.new_state}"
    end
  end
end