require 'rspec'
require_relative '../../../lib/state_table/state_transition_gene'
require_relative '../../../lib/state_table/state_transition'
require_relative 'numeric_gene_stub'

describe StateTransitionGene do
  let(:nr_tested_examples) { 100 }
  let(:gene) { StateTransitionGene.new(
      NumericGeneStub.new(new_symbol_value, new_symbol_mutated_value),
      NumericGeneStub.new(direction_value, direction_mutated_value),
      NumericGeneStub.new(new_state_value, new_state_mutated_value)) }
  let(:new_symbol_value) { 1 }
  let(:new_symbol_mutated_value) { 5 }
  let(:direction_value) { 5 }
  let(:direction_mutated_value) { 8 }
  let(:new_state_value) { 10 }
  let(:new_state_mutated_value) { 51 }

  describe 'mutate' do
    it 'mutates new_symbol sometimes' do
      new_symbol_has_changed = nr_tested_examples.times.any? do
        gene.mutate.decode.new_symbol.eql?(new_symbol_mutated_value)
      end

      expect(new_symbol_has_changed).to be_truthy
    end
    it 'mutates direction sometimes' do
      direction_has_changed = nr_tested_examples.times.any? do
        gene.mutate.decode.direction.eql?(direction_mutated_value)
      end

      expect(direction_has_changed).to be_truthy
    end
    it 'mutates new_state sometimes' do
      new_state_has_changed = nr_tested_examples.times.any? do
        gene.mutate.decode.new_state.eql?(new_state_mutated_value)
      end

      expect(new_state_has_changed).to be_truthy
    end
    it 'mutates only new_symbol, direction or new_state but not more than one' do
      all_xor = nr_tested_examples.times.all? do
        mutated_transition = gene.mutate.decode
        new_symbol_changed = mutated_transition.new_symbol.eql?(new_symbol_mutated_value)
        direction_changed = mutated_transition.direction.eql?(direction_mutated_value)
        new_state_changed = mutated_transition.new_state.eql?(new_state_mutated_value)

        (new_symbol_changed ^ direction_changed ^ new_state_changed) &&
            !(new_symbol_changed && direction_changed && new_state_changed)
      end
      expect(all_xor).to be_truthy
    end

  end

  describe 'decode' do
    it { expect(gene.decode).to be_a(StateTransition) }
    it { expect(gene.decode).to eq(StateTransition.new(new_symbol_value, direction_value, new_state_value)) }
  end

  describe 'eql?' do
    it { expect(StateTransitionGene.new(1, 2, 3)).to eq(StateTransitionGene.new(1, 2, 3)) }
    it { expect(StateTransitionGene.new(1, 2, 3)).not_to eq(StateTransitionGene.new(2, 2, 3)) }
    it { expect(StateTransitionGene.new(1, 2, 3)).not_to eq(StateTransitionGene.new(1, 3, 3)) }
    it { expect(StateTransitionGene.new(1, 2, 3)).not_to eq(StateTransitionGene.new(1, 2, 4)) }
    it { expect(StateTransitionGene.new(1, 2, 3)).not_to eq(8) }
  end

end