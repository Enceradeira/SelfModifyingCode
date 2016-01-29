require_relative 'program'
require_relative 'test_case'
require_relative 'state_table'
require_relative 'state_table_row'
require_relative 'state_input'

class ProgramFactory
  private

  public
  def build(test_cases_array)

    test_cases = test_cases_array.map { |t| TestCase.new(t) }

    input_symbols = test_cases.map { |c| c.input }.flatten.uniq
    output_symbols = test_cases.map { |c| c.expected_output }.flatten.uniq

    table = init_table(input_symbols, output_symbols)
    program = Program.new(table)
    until test_cases.all? { |c| c.passes_for?(program) } do
      table = init_table(input_symbols, output_symbols)
      program = Program.new(table)
      puts '-------'
      puts program.to_source
      puts '-------'
    end

    program.to_source
  end

  def init_table(input_symbols, output_symbols)
    i = (input_symbols + [nil]).uniq
    o = (output_symbols + [nil]).uniq

    d = [:r, :l, nil]

    states = %w(false undecided)
    nr_rows = 6

    is = ['init'] + states
    os = ['accept'] + states
    c = {}
    StateTable.new(nr_rows.times.map { StateTableRow.new(build_uniq_state_input(i, is, c), StateTransition.new(o.sample, d.sample, os.sample)) })
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