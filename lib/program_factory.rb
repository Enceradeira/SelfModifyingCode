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

    # fix
    key_words = %w(, ->)
    directions = %w(r l -)
    default_states = %w(init accept)
    input_symbols =

        # variable
        size = 0

    table = StateTable.new([
                               StateTableRow.new(StateInput.new('init', '0'), StateTransition.new(nil, :r, 'false')),
                               StateTableRow.new(StateInput.new('init', '1'), StateTransition.new(nil, :r, 'undecided')),
                               StateTableRow.new(StateInput.new('false', '0'), StateTransition.new('0', nil, 'accept')),
                               StateTableRow.new(StateInput.new('false', '1'), StateTransition.new('0', nil, 'accept')),
                               StateTableRow.new(StateInput.new('undecided', '0'), StateTransition.new('0', nil, 'accept')),
                               StateTableRow.new(StateInput.new('undecided', '1'), StateTransition.new('1', nil, 'accept'))])


    program = Program.compile(%w())
    until test_cases.all? { |c| c.passes_for?(program) } do
      program = Program.new(table)
    end

    program.to_source
  end
end