require_relative 'program'
require_relative 'test_case'
require_relative 'state_table'
require_relative 'state_table_row'
require_relative 'state_input'
require_relative 'symbols'

class ProgramFactory
  private

  public
  def build(test_cases_array)

    test_cases = test_cases_array.map { |t| TestCase.new(t) }
    symbols = Symbols.new(test_cases)

    program = create_program(symbols)
    until test_cases.all? { |c| c.passes_for?(program) } do
      program = Program.new(init_table(symbols))
      puts '-------'
      puts program.to_source
      puts '-------'
    end

    program.to_source
  end

  def create_program(symbols)
    table = init_table(symbols)
    Program.new(table)
  end

  def init_table(symbols)
    nr_states = 2
    nr_rows = 6

    states = nr_states.times.map{|s| s.to_s.to_sym}
    is = [INIT_STATE] + states
    os = [ACCEPT_STATE] + states
    c = {}
    rows = nr_rows.times.map do
      state_input = build_uniq_state_input(symbols.for_input, is, c)
      transition = StateTransition.new(symbols.for_output.sample, DIRECTIONS.sample, os.sample)
      StateTableRow.new(state_input, transition)
    end
    StateTable.new(rows)
  end

  def build_uniq_state_input(i, is, hash)
    loop do
      state = is.sample
      input = i.sample
      key = "#{state};#{input}"
      unless hash.has_key?(key)
        return StateInput.new(state, input)
      end
    end
  end
end