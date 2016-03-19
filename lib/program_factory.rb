require_relative 'program'
require_relative 'test_case'
require_relative 'symbols'
require_relative 'state_table/chromosome'

class ProgramFactory
  def initialize(resources)
    @resources = resources
  end

  public
  def build(test_cases_array)

    test_cases = test_cases_array.map { |t| TestCase.new(t) }
    symbols = Symbols.new(test_cases)

    chromosome  = Chromosome.create
    program = Program.new(StateTable.new(chromosome.decode))

    nr = test_cases.count
    nr_ok = test_cases.count { |c| c.passes_for?(program, @resources) }
    until nr_ok == nr do

      chromosome = chromosome.mutate
      program  = Program.new(StateTable.new(chromosome.decode))
      nr_ok = test_cases.count { |c| c.passes_for?(program, @resources) }
    end

    program.to_source
  end


end