require 'rspec'
require_relative 'numeric_gene_stub'
require_relative 'state_table_rows_gene_stub'
require_relative 'state_table_row_gene_stub'
require_relative '../../../lib/state_table/state_table_row'
require_relative '../../../lib/state_table/state_input'
require_relative '../../../lib/state_table/state_transition'
require_relative '../../../lib/state_table/chromosome'

describe Chromosome do
  let(:nr_tested_examples) { 100 }
  let(:nr_states_gene_mutated_value) { 9 }
  let(:nr_states_gene_value) { 7 }
  let(:nr_states_gene) { NumericGeneStub.new(nr_states_gene_value, nr_states_gene_mutated_value) }
  let(:rows_gene_value) { 6 }
  let(:rows_gene_mutated_value) { 8 }
  let(:rows_gene) { StateTableRowsGeneStub.new(rows_gene_value, rows_gene_mutated_value) }
  let(:chromosome) { Chromosome.new(rows_gene) }
  let(:symbols) { [:A, :X] }

  describe 'create' do
    it { expect(Chromosome.create(symbols)).not_to be_nil }

  end

  describe 'decode' do
    it { expect(chromosome.decode).to eq(rows_gene_value) }
  end

  describe 'mutate' do
    it 'returns another Chromosome' do
      mutation = chromosome.mutate
      expect(mutation).to be_a(Chromosome)
    end
  end

  describe 'eql?' do
    it 'is true when same' do
      expect(chromosome).to eq(chromosome)
    end
    it 'is true when same values' do
      chromosome_a = Chromosome.new(2)
      chromosome_b = Chromosome.new(2)
      expect(chromosome_a).to eq(chromosome_b)
    end
    it 'is false when not same values' do
      chromosome_a = Chromosome.new(3)
      chromosome_b = Chromosome.new(2)
      expect(chromosome_a).not_to eq(chromosome_b)
    end
    it { expect(Chromosome.new(4)).to_not eq('G') }
  end
end