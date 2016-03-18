require 'rspec'
require_relative '../../../lib/state_table/state_input_gene'
require_relative 'numeric_gene_stub'

describe StateInputGene do
  let(:nr_tested_examples) { 50 }
  let(:gene) { StateInputGene.new(
      NumericGeneStub.new(state_value, state_mutated_value),
      NumericGeneStub.new(symbol_value, symbol_mutated_value)) }
  let(:state_value) { 3 }
  let(:state_mutated_value) { 6 }
  let(:symbol_value) { 45 }
  let(:symbol_mutated_value) { 1 }

  describe 'decode' do
    it { expect(gene.decode).to be_a(StateInput) }
    it { expect(gene.decode).to eq(StateInput.new(state_value, symbol_value)) }
  end

  describe 'mutate' do
    it 'mutates state sometimes' do
      state_has_changed = nr_tested_examples.times.any? do
        gene.mutate.decode.state.eql?(state_mutated_value)
      end
      expect(state_has_changed).to be_truthy
    end
    it 'mutates input sometimes' do
      input_has_changed = nr_tested_examples.times.any? do
        gene.mutate.decode.symbol.eql?(symbol_mutated_value)
      end
      expect(input_has_changed).to be_truthy
    end
    it 'mutates input or state but not both' do
      all_xor = nr_tested_examples.times.all? do
        mutated_transition = gene.mutate.decode
        input_changed =mutated_transition.symbol.eql?(symbol_mutated_value)
        state_changed = mutated_transition.state.eql?(state_mutated_value)
        input_changed ^ state_changed
      end
      expect(all_xor).to be_truthy
    end

  end

  describe 'eql?' do
    it { expect(StateInputGene.new(1, 2)).to eq(StateInputGene.new(1, 2)) }
    it { expect(StateInputGene.new(1, 2)).not_to eq(StateInputGene.new(2, 2)) }
    it { expect(StateInputGene.new(1, 2)).not_to eq(StateInputGene.new(1, 3)) }
    it { expect(StateInputGene.new(1, 2)).not_to eq(8) }
  end

end