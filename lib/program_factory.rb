require_relative 'program'
require_relative 'test_case'
require_relative 'symbols'

class ProgramFactory
  private

  public
  def build(test_cases_array)

    test_cases = test_cases_array.map { |t| TestCase.new(t) }
    symbols = Symbols.new(test_cases)

    program = create_program(symbols)
    until test_cases.all? { |c| c.passes_for?(program) } do
      program = create_program(symbols)
      puts '-------'
      puts program.to_source
      puts '-------'
    end

    program.to_source
  end

  def create_program(symbols)
    nr_states = 2
    nr_rows = 6

    Program.create_random(nr_rows, nr_states, symbols)
  end
end