require 'rspec'
require_relative 'numeric_gene_stub'
require_relative 'state_table_rows_gene_stub'
require_relative '../../../lib/state_table/state_table_row'
require_relative '../../../lib/state_table/state_input'
require_relative '../../../lib/state_table/state_transition'
require_relative '../../../lib/state_table/chromosome'

describe Chromosome do
  let(:nr_tested_examples) { 100 }
  let(:nr_states_gene_mutated_value) { 9 }
  let(:nr_states_gene_value) { 7 }
  let(:nr_states_gene) { NumericGeneStub.new(nr_states_gene_value, nr_states_gene_mutated_value) }
  let(:rows_gene_value) { [1, 2] }
  let(:rows_gene_mutated_value) { [1, 2, 1] }
  let(:rows_gene) { StateTableRowsGeneStub.new(rows_gene_value, rows_gene_mutated_value) }
  let(:chromosome) { Chromosome.new(nr_states_gene, rows_gene) }

  describe 'create' do
    it { expect(Chromosome.create).not_to be_nil }

  end

  describe 'decode' do
    it { expect(chromosome.decode.count).to eq(2) }
  end

  describe 'mutate' do
    it 'mutates exactly one gene but not both' do
      mutation = chromosome.mutate
      mutated_nr_states_gene = mutation.nr_states
      mutated_rows_gene = mutation.rows_gene
      expect(mutated_nr_states_gene.eql?(nr_states_gene) ^ mutated_rows_gene.eql?(rows_gene)).to be_truthy
    end
    it 'returns another Chromosome' do
      mutation = chromosome.mutate
      expect(mutation).not_to be_nil
    end
    it 'mutates nr_states sometimes' do
      nr_states_was_mutated = false
      nr_tested_examples.times.each do
        mutation = chromosome.mutate
        nr_states_was_mutated = !mutation.nr_states.eql?(chromosome.nr_states)
        break if nr_states_was_mutated
      end
      expect(nr_states_was_mutated).to be_truthy
    end
    it 'mutates row_genes sometimes' do
      rows_gene_was_mutated = false
      nr_tested_examples.times.each do
        mutation = chromosome.mutate
        rows_gene_was_mutated = !mutation.rows_gene.eql?(chromosome.rows_gene)
        break if rows_gene_was_mutated
      end
      expect(rows_gene_was_mutated).to be_truthy
    end
  end

  describe 'eql?' do
    it 'is true when same' do
      expect(chromosome).to eq(chromosome)
    end
    it 'is true when same values' do
      chromosome_a = Chromosome.new(1, 2)
      chromosome_b = Chromosome.new(1, 2)
      expect(chromosome_a).to eq(chromosome_b)
    end
    it 'is false when not same values' do
      chromosome_a = Chromosome.new(1, 3)
      chromosome_b = Chromosome.new(1, 2)
      expect(chromosome_a).not_to eq(chromosome_b)
    end
  end
end