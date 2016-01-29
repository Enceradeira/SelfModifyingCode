class StateTable
  attr_reader :rows

  def initialize(rows)
    @rows = rows
  end

  class << self
    private

    def build_uniq_state_input(i, is, hash)
      loop do
        state = is.sample
        input = i.sample
        key = "#{state};#{input}"
        unless hash.has_key?(key)
          return StateInput.new(state, input)
        end
      end
    end

    public

    def create_random(nr_rows, nr_states, symbols)
      states = nr_states.times.map { |s| s.to_s.to_sym }
      is = [INIT_STATE] + states
      os = [ACCEPT_STATE] + states
      c = {}
      rows = nr_rows.times.map do
        state_input = build_uniq_state_input(symbols.for_input, is, c)
        transition = StateTransition.new(symbols.for_output.sample, DIRECTIONS.sample, os.sample)
        StateTableRow.new(state_input, transition)
      end
      StateTable.new(rows)
    end
  end
end