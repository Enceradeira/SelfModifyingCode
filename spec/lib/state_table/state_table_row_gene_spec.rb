require 'rspec'
require_relative '../../../lib/state_table/state_table_row_gene'

describe StateTableRowGene do

  describe 'create' do
    it { expect(StateTableRowGene.create).to be_a(StateTableRowGene) }
  end
end