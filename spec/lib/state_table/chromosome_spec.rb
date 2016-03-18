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
  let(:rows_gene_value) { 8 }
  let(:rows_gene_mutated_value) { 87 }
  let(:rows_gene) { StateTableRowsGeneStub.new(rows_gene_value, rows_gene_mutated_value) }
  let(:chromosome) { Chromosome.new(nr_states_gene, rows_gene) }

  describe 'create' do
    it { expect(Chromosome.create).not_to be_nil }

  end

  describe 'decode' do
    it { expect(chromosome.decode.count).to eq(2) }
  end

  describe 'mutate' do
    it 'returns another Chromosome' do
      mutation = chromosome.mutate
      expect(mutation).not_to be_nil
    end

    it 'mutates nr_states sometimes' do
      has_nr_states_changed= nr_tested_examples.times.any? do
        mutation = chromosome.mutate.decode
        mutation[:nr_states].eql?(nr_states_gene_mutated_value)
      end
      expect(has_nr_states_changed).to be_truthy
    end

    it 'mutates rows sometimes' do
      has_rows_changed= nr_tested_examples.times.any? do
        mutation = chromosome.mutate.decode
        mutation[:rows].eql?(rows_gene_mutated_value)
      end
      expect(has_rows_changed).to be_truthy
    end
    it 'mutates nr_states or rows but not both' do
      changes_xor = nr_states_gene_mutated_value.times.all? do
        mutation = chromosome.mutate.decode
        nr_states_changed = mutation[:nr_states].eql?(nr_states_gene_mutated_value)
        rows_changed = mutation[:rows].eql?(rows_gene_mutated_value)
        nr_states_changed ^ rows_changed
      end
      expect(changes_xor).to be_truthy
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
    it { expect(Chromosome.new(3, 4)).to_not eq('G') }
  end
end