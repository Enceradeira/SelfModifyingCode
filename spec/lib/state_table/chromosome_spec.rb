require 'rspec'
require_relative '../../../lib/state_table/chromosome'
require_relative '../../../lib/state_table/state_table_row_gene'
require_relative '../../../lib/constants'
require_relative '../../../lib/state_table/vocabulary'
require_relative 'numeric_gene_stub'
require_relative 'state_table_row_gene_stub'
require_relative '../symbols_stub'

describe Chromosome do
  let(:nr_tested_examples) { 100 }
  let(:nr_rows) { 3 }
  let(:nr_rows_mutated) { 100 }
  let(:rows_genes) { nr_rows.times.map { StateTableRowGene.create(vocabulary) } }
  let(:nr_states) { 2 }
  let(:nr_states_mutated) { 5 }
  let(:gene) { Chromosome.new(
      NumericGeneStub.new(nr_rows, nr_rows_mutated),
      rows_genes,
      NumericGeneStub.new(nr_states, nr_states_mutated),
      vocabulary) }
  let(:row_gene_factory) { StateTableRowGeneStub.new(0, -1) }
  let(:symbols) { SymbolsStub.new([:A, :C, :F], [:AA, :AC, :AD]) }
  let(:vocabulary) { Vocabulary.new(nr_states, symbols) }

  describe 'create' do
    it { expect(Chromosome.create(symbols)).to be_a(Chromosome) }
  end

  describe 'decode' do
    it 'decodes all rows_genes' do
      rows = gene.decode
      expect(rows).to match_array(rows_genes.map { |g| g.decode })
    end
  end

  describe 'mutate' do

    def has_nr_rows_changed(mutation)
      mutation.count == nr_rows_mutated
    end

    def has_one_row_changed(original_gene, mutation)
      existing_rows = original_gene.decode
      mutation.count == nr_rows && mutation.select { |m| !existing_rows.include?(m) }.count == 1
    end

    def has_nr_states_changed(mutation)
      20.times.any? do
        # test that a consecutive mutation uses an additional  'states'
        mutation.mutate.decode.map { |r| r.state_input.state }.uniq.select { |s| s!=INIT_STATE }.count > nr_states
      end
    end

    it 'mutates nr_rows sometimes' do
      nr_rows_changed = nr_tested_examples.times.any? { has_nr_rows_changed(gene.mutate.decode) }
      expect(nr_rows_changed).to be_truthy
    end

    it 'mutates exactly one row sometimes' do
      row_changed = nr_tested_examples.times.any? { has_one_row_changed(gene, gene.mutate.decode) }
      expect(row_changed).to be_truthy
    end

    it 'mutates nr_states sometimes' do
      nr_states_changed = nr_tested_examples.times.any? {
        has_nr_states_changed(gene.mutate)
      }
      expect(nr_states_changed).to be_truthy
    end

    it 'mutates nr_rows, nr_states or a row but exclusively' do
      all_changes_xor = nr_tested_examples.times.all? {
        mutated_gene = gene.mutate
        mutation = mutated_gene.decode
        has_one_row_changed = has_one_row_changed(gene, mutation)
        has_nr_rows_changed = has_nr_rows_changed(mutation)
        has_nr_states_changed = has_nr_states_changed(mutated_gene)
        has_one_row_changed ^ has_nr_rows_changed ^ has_nr_states_changed &&
            !(has_one_row_changed && has_nr_rows_changed && has_nr_states_changed)
      }
      expect(all_changes_xor).to be_truthy
    end

    context 'when nr_rows' do
      let(:mutation) do
        nr_tested_examples.times.map { gene.mutate }.select { |m| m.decode.count == nr_rows_mutated }.first
      end
      let (:rows_before_mutation) { rows_genes.map { |r| r.decode } }
      let (:rows_after_mutation) { mutation.decode }
      let(:unchanged_rows) { rows_after_mutation.select { |m| rows_before_mutation.include?(m) } }
      let(:changed_rows) { rows_after_mutation.select { |m| !rows_before_mutation.include?(m) } }

      context 'increases' do
        let(:nr_rows) { 3 }
        let(:nr_rows_mutated) { nr_rows + 2 }

        it 'adds rows' do
          expect(mutation).to_not be_nil
        end

        it 'add correct number of rows' do
          expect(changed_rows.count).to eq(nr_rows_mutated-nr_rows)
        end

        it 'does not change existing rows and their order' do
          expect(unchanged_rows).to be == rows_before_mutation
        end

        it 'adds rows at a random position' do
          new_state_value = 100
          row_mutations = nr_tested_examples.times.map { gene.mutate {
            new_state_value = new_state_value + 1
            StateTableRowGeneStub.new(new_state_value, new_state_value) }
          }.select { |m| m.decode.count == nr_rows_mutated }.map { |m| m.decode }

          indexes_where_inserted = row_mutations.map do |r|
            r.select { |m| !rows_before_mutation.include?(m) }.map { |e| r.index(e) }
          end.flatten.uniq

          expect(indexes_where_inserted).to contain_exactly(0, 1, 2, 3, 4)
        end
      end

      context 'decreases' do
        let(:nr_rows) { 7 }
        let(:nr_rows_mutated) { nr_rows - 4 }

        it 'removes rows' do
          expect(mutation).to_not be_nil
        end

        it 'does not change remaining rows and their order' do
          expect(unchanged_rows).to be == rows_after_mutation.select { |r| rows_before_mutation.include?(r) }
        end

        it 'removes rows at a random position' do
          row_mutations = nr_tested_examples.times.map { gene.mutate }.select { |m| m.decode.count == nr_rows_mutated }.map { |m| m.decode }

          indexes_where_deleted = row_mutations.map do |r|
            rows_before_mutation.select { |b| !r.include?(b) }.map { |e| rows_before_mutation.index(e) }
          end.flatten.uniq

          expect(indexes_where_deleted).to contain_exactly(0, 1, 2, 3, 4, 5, 6)
        end
      end
    end
  end
end