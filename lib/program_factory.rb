require_relative 'program'
require_relative 'test_case'
require_relative 'symbols'

class ProgramFactory
  def initialize(resources)
    @resources = resources
  end

  public
  def build(test_cases_array)

    test_cases = test_cases_array.map { |t| TestCase.new(t) }
    symbols = Symbols.new(test_cases)

    program = Program.create_random(symbols)

    nr = test_cases.count
    nr_ok = test_cases.count { |c| c.passes_for?(program, @resources) }
    until nr_ok == nr do
      program = program.mutate(symbols)
      nr_ok = test_cases.count { |c| c.passes_for?(program, @resources) }
    end

    program.to_source
  end


end