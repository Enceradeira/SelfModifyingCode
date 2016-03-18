require 'rspec'
require_relative '../../../lib/state_table/state_table_rows_gene'
require_relative '../../../lib/state_table/state_table_row_gene'
require_relative 'numeric_gene_stub'

describe StateTableRowsGene do
  let(:nr_tested_examples) { 100 }
  let(:nr_rows) { 3 }
  let(:nr_rows_mutated) { 4 }
  let(:gene) { StateTableRowsGene.create(NumericGeneStub.new(nr_rows, nr_rows_mutated)) }

  describe 'create' do

    it { expect(gene).to_not be_nil }

    describe 'rows' do
      it { expect(gene.rows_genes.count).to eq(nr_rows) }
      it { expect(gene.rows_genes).to all(be_a(StateTableRowGene)) }
    end
  end

  describe 'mutate' do

    it 'mutates nr_rows sometimes' do
      nr_rows_was_mutated = false
      nr_tested_examples.times.each do
        mutated_gene = gene.mutate
        nr_rows_was_mutated = !mutated_gene.nr_rows_gene.eql?(gene.nr_rows_gene)
        break if nr_rows_was_mutated
      end
      expect(nr_rows_was_mutated).to be_truthy
    end

    it 'mutates exactly one row gene sometimes' do
      one_row_gene_was_mutated = false
      nr_tested_examples.times.each do
        mutated_gene = gene.mutate
        rows_genes = gene.rows_genes.zip(mutated_gene.rows_genes)
        changed_row_genes = rows_genes.select { |p| !p[0].eql?(p[1]) }
        one_row_gene_was_mutated = changed_row_genes.count == 1
        break if one_row_gene_was_mutated
      end
      expect(one_row_gene_was_mutated).to be_truthy
    end

    it 'never mutates several row genes' do
      nr_changed_rows = nr_tested_examples.times.map do
        mutated_gene = gene.mutate
        rows_genes = gene.rows_genes.zip(mutated_gene.rows_genes)
        changed_rows_genes = rows_genes.select { |p| !p[0].eql?(p[1]) }
        changed_rows_genes.count
      end.select { |nr| nr>1 }

      expect(nr_changed_rows).to be_empty
    end

    it 'mutates nr_rows or a row but not both' do
      nr_changed_xor_rows_changed= nr_tested_examples.times.map do
        mutated_gene = gene.mutate
        rows_genes = gene.rows_genes.zip(mutated_gene.rows_genes)
        nr_rows_was_mutated = !mutated_gene.nr_rows_gene.eql?(gene.nr_rows_gene)
        rows_genes_was_mutated = rows_genes.any? { |p| !p[0].eql?(p[1]) }
        nr_rows_was_mutated ^ rows_genes_was_mutated
      end.uniq

      expect(nr_changed_xor_rows_changed).to contain_exactly(true)
    end
  end

end