require 'rspec'
require_relative '../../../lib/state_table/state_table_rows_gene'
require_relative '../../../lib/state_table/state_table_row_gene'
require_relative 'numeric_gene_stub'

describe StateTableRowsGene do
  describe 'create' do
    let(:nr_created_rows) { 3 }
    let(:created_gene) { StateTableRowsGene.create(NumericGeneStub.new(nr_created_rows, nr_created_rows)) }
    it { expect(created_gene).to_not be_nil }

    describe 'rows' do
      it { expect(created_gene.rows.count).to eq(nr_created_rows) }
      it {expect(created_gene.rows).to all(be_a(StateTableRowGene))}
    end
  end


end