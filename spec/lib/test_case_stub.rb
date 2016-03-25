class TestCaseStub
  private
  def initialize(is_passing, nr_machine_cycles)
    @is_passing = is_passing
    @nr_machine_cycles = nr_machine_cycles
  end

  public
  def passes_for?(program, resources)
    if program.nil?
      raise StandardError.new 'no program provided'
    end
    if resources.nil?
      raise StandardError.new 'no resources provided'
    end
    return {:is_ok => @is_passing, :used_machine_cycles => @nr_machine_cycles}
  end
end