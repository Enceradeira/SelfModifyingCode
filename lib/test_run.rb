class TestRun
  private
  def initialize(program, test_cases, resources)
    @program = program
    @test_cases = test_cases
    @resources = resources
    @test_results = @test_cases.map { |c| c.passes_for?(program, @resources) }
  end

  protected
  attr_reader :program

  def nr_ok
    @nr_ok ||= @test_results.count { |r| r[:is_ok] }
  end

  def nr_machine_cycles
    @nr_machine_cycles ||= @test_results.reduce(0) { |sum, r| sum + r[:used_machine_cycles] }
  end

  public
  def all_tests_ok?
    self.nr_ok == @test_cases.count
  end

  def is_better_than?(other_test_run)
    # test results (Prio 1)
    if self.nr_ok > other_test_run.nr_ok
      return true
    end
    if self.nr_ok < other_test_run.nr_ok
      return false
    end

    # execution time
    if self.nr_machine_cycles < other_test_run.nr_machine_cycles
      return true
    end

    # program size (not implemented yet)
    if self.program.is_smaller_than?(other_test_run.program)
      return true
    end

    # less tape (not implemented yet)

    false
  end
end
