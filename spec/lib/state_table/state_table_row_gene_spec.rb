require 'rspec'
require_relative '../../../lib/state_table/state_table_row_gene'
require_relative '../../../lib/state_table/state_transition'
require_relative 'state_input_gene_stub'
require_relative 'state_transition_gene_stub'
require_relative '../../../lib/state_table/state_input'
require_relative '../../../lib/state_table/state_table_row'
require_relative '../../../lib/state_table/vocabulary'

describe StateTableRowGene do
  let(:gene) { StateTableRowGene.new(state_input_gene, transition_gene) }
  let(:state_input) { 0 }
  let(:state_input_mutated) { 1 }
  let(:state_input_gene) { StateInputGeneStub.new(state_input, state_input_mutated) }
  let(:state_transition) { :rlf };
  let(:state_transition_mutated) { :sre };
  let(:transition_gene) { StateTransitionGeneStub.new(state_transition, state_transition_mutated) }
  let(:nr_tested_examples) { 100 }
  let(:vocabulary) { Vocabulary.new(2, [:F]) }

  describe 'create' do
    it { expect(StateTableRowGene.create(vocabulary)).to be_a(StateTableRowGene) }
  end

  describe 'decode' do
    it { expect(gene.decode).to be_a(StateTableRow) }
    it { expect(gene.decode.state_input).to eq(state_input) }
    it { expect(gene.decode.transition).to eq(state_transition) }
  end

  describe 'mutate' do
    it 'mutates state_input sometimes' do
      has_state_input_changed = false
      nr_tested_examples.times.each do
        mutated_row = gene.mutate(vocabulary).decode
        original_row = gene.decode
        has_state_input_changed = !mutated_row.state_input.eql?(original_row.state_input)
        break if has_state_input_changed
      end
      expect(has_state_input_changed).to be_truthy
    end
    it 'mutates state_transition sometimes' do
      has_transition_changed = false
      nr_tested_examples.times.each do
        mutated_row = gene.mutate(vocabulary).decode
        original_row = gene.decode
        has_transition_changed = !mutated_row.transition.eql?(original_row.transition)
        break if has_transition_changed
      end
      expect(has_transition_changed).to be_truthy
    end
    it 'always mutates state_input or state_tranisition' do
      si_changed_xor_tr_changed = nr_tested_examples.times.map do
        mutated_row = gene.mutate(vocabulary).decode
        original_row = gene.decode
        si_changed = !mutated_row.state_input.eql?(original_row.state_input)
        transition_changed = !mutated_row.transition.eql?(original_row.transition)
        si_changed ^ transition_changed
      end.uniq

      expect(si_changed_xor_tr_changed).to contain_exactly(true)

    end
  end

  describe 'eql?' do
    it { expect(StateTableRowGene.new(6, 1)).to eq(StateTableRowGene.new(6, 1)) }
    it { expect(StateTableRowGene.new(5, 1)).to_not eq(StateTableRowGene.new(6, 1)) }
    it { expect(StateTableRowGene.new(5, 1)).to_not eq(StateTableRowGene.new(5, 2)) }
  end

end