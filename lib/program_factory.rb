require_relative 'program'
require_relative 'test_case'
require_relative 'symbols'
require_relative 'test_run'
require_relative 'state_table/chromosome'
require_relative 'log'

class ProgramFactory
  private
  def initialize(resources)
    @resources = resources
  end

  def create_program(chromosome)
    Program.new(StateTable.new(chromosome.decode))
  end

  public
  def build(test_cases_array)
    nr_mutations = 1
    test_cases = test_cases_array.map { |t| TestCase.new(t) }
    symbols = Symbols.new(test_cases)

    best_chromosome = Chromosome.create(symbols)
    best_test_run = TestRun.new(create_program(best_chromosome), test_cases, @resources)

    until best_test_run.all_tests_ok? do

      mutated_chromosome = best_chromosome.mutate
      mutated_program = create_program(mutated_chromosome)
      test_run = TestRun.new(mutated_program, test_cases, @resources)

      if test_run.is_better_than?(best_test_run)
        best_test_run = test_run
        best_chromosome = mutated_chromosome
      end
      nr_mutations = nr_mutations + 1

      log "Best: #{best_test_run.get_description}\tmutations: #{nr_mutations}"
      log "Curr: #{test_run.get_description}"
      log "Curr: #{mutated_chromosome.get_description}"

    end

    create_program(best_chromosome).to_source
  end


end