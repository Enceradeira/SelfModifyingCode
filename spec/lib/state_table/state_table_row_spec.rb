require 'rspec'
require_relative '../../../lib/state_table/state_input'
require_relative '../../../lib/state_table/state_table_row'

describe StateTableRow do
  describe '==' do
    it { expect(StateTableRow.new(1, 1)).to eq(StateTableRow.new(1, 1)) }
    it { expect(StateTableRow.new(1, 1)).not_to eq(StateTableRow.new(1, 2)) }
    it { expect(StateTableRow.new(2, 1)).not_to eq(StateTableRow.new(1, 1)) }
    it { expect(StateTableRow.new(nil, 1)).not_to eq(StateTableRow.new(1, 1)) }
    it { expect(StateTableRow.new(1, 1)).not_to eq(StateTableRow.new(1, nil)) }
  end

  describe 'eql?' do
    it { expect(StateTableRow.new(1, 1).eql?(StateTableRow.new(1, 1))).to eq(true) }
  end
end