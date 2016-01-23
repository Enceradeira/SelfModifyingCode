require_relative 'program'
require_relative 'test_case'

class ProgramFactory
  private

  public
  def build(test_cases_array)

    test_cases = test_cases_array.map { |t| TestCase.new(t) }

    # fix
    key_words = %w(, ->)
    directions = %w(r l -)
    default_states = %w(init accept)
    input_symbols =

        # variable
        size = 0


    table = Array.new(size)
    program = Program.new(%w())
    until test_cases.all? { |c| c.test(program) } do
      program = Program.new(%w(
        init,0->,r,false
        init,1->,r,undecided
        false,0->0,-,accept
        false,1->0,-,accept
        undecided,0->0,-,accept
        undecided,1->1,-,accept))
    end

    program.to_source
  end
end