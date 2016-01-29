require_relative 'program'
require_relative 'test_case'
require_relative 'symbols'

class ProgramFactory
  def initialize(resources)
    @resources = resources
    @progress = 0
    @nr_states = 2
    @nr_rows = 6
    @max_passing_tests = 0
  end

  private
  def create_program(symbols)
    Program.create_random(@nr_rows, @nr_states, symbols)
  end

  def mutate_program(symbols)
    @progress = @progress + 1
    if @progress == 10000
      @nr_states = @nr_states + 1
    end
    if @progress == 20000
      @nr_rows = @nr_rows + 1
      @progress = 0

      puts "INFO: nr_states:#{@nr_states}\tnr_rows:#{@nr_rows}"
    end

    Program.create_random(@nr_rows, @nr_states, symbols)
  end

  public
  def build(test_cases_array)

    test_cases = test_cases_array.map { |t| TestCase.new(t) }
    symbols = Symbols.new(test_cases)

    program = create_program(symbols)
    nr_test_cases = test_cases.count
    nr_passing_test_cases = test_cases.count { |c| c.passes_for?(program, @resources) }
    until nr_passing_test_cases == nr_test_cases do
      program = mutate_program(symbols)
      nr_passing_test_cases = test_cases.count { |c| c.passes_for?(program,@resources) }

      if nr_passing_test_cases > @max_passing_tests
        @max_passing_tests = nr_passing_test_cases
      end

      puts "INFO: passing_tests:#{nr_passing_test_cases}\tmax_passing_tests:#{@max_passing_tests}"


=begin
      puts '-------'
      puts program.to_source
      puts '-------'
=end
    end

    program.to_source
  end


end