class ProgramFake
  private
  def initialize(program_size)
    @program_size = program_size
  end

  protected
  attr_reader :program_size

  public
  def is_smaller_than?(other_program)
    @program_size < other_program.program_size
  end
end