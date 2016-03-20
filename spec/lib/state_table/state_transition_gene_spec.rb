require 'rspec'
require_relative '../../../lib/state_table/state_transition_gene'
require_relative '../../../lib/state_table/state_transition'
require_relative '../../../lib/constants'
require_relative '../../../lib/state_table/vocabulary'
require_relative 'numeric_gene_stub'
require_relative '../symbols_stub'

describe StateTransitionGene do
  let(:nr_tested_examples) { 100 }
  let(:gene) { StateTransitionGene.new(output_symbol1, direction1, state1) }
  let(:direction1) { LEFT }
  let(:state1) { 0 }
  let(:state2) { 1 }
  let(:output_symbol1) { 'A' }
  let(:output_symbol2) { 'DF' }
  let(:states) { [state1, state2] }
  let(:states_including_accept) { Array.new(states).concat([ACCEPT_STATE]) }
  let(:symbols_including_nil) { Array.new(symbols.for_output).concat([nil]) }
  let(:symbols) { SymbolsStub.new([10, 76], [output_symbol1, output_symbol2]) }
  let(:vocabulary) { Vocabulary.new(states.count, symbols) }

  describe 'create' do
    let(:gene) { StateTransitionGene.create(vocabulary) }
    it { expect(gene).to be_a(StateTransitionGene) }
    it { expect(gene.decode.new_state).to satisfy { |e| states_including_accept.include?(e) } }
    it { expect(gene.decode.new_symbol).to satisfy { |e| symbols_including_nil.include?(e) } }
    it { expect(gene.decode.direction).to(satisfy) { |e| DIRECTIONS.include?(e) } }
  end

  describe 'mutate' do
    it 'mutates new_symbol sometimes' do
      new_symbol_has_changed = nr_tested_examples.times.any? do
        !gene.mutate(vocabulary).decode.new_symbol.eql?(output_symbol1)
      end

      expect(new_symbol_has_changed).to be_truthy
    end
    it 'mutates direction sometimes' do
      direction_has_changed = nr_tested_examples.times.any? do
        !gene.mutate(vocabulary).decode.direction.eql?(direction1)
      end

      expect(direction_has_changed).to be_truthy
    end
    it 'mutates new_state sometimes' do
      new_state_has_changed = nr_tested_examples.times.any? do
        !gene.mutate(vocabulary).decode.new_state.eql?(state1)
      end

      expect(new_state_has_changed).to be_truthy
    end
    it 'mutates only new_symbol, direction or new_state but not more than one' do
      all_xor = nr_tested_examples.times.all? do
        mutated_transition = gene.mutate(vocabulary).decode
        new_symbol_changed = !mutated_transition.new_symbol.eql?(output_symbol1)
        direction_changed = !mutated_transition.direction.eql?(direction1)
        new_state_changed = !mutated_transition.new_state.eql?(state1)

        (new_symbol_changed ^ direction_changed ^ new_state_changed) &&
            !(new_symbol_changed && direction_changed && new_state_changed)
      end
      expect(all_xor).to be_truthy
    end

  end

  describe 'decode' do
    it { expect(gene.decode).to be_a(StateTransition) }
    it { expect(gene.decode).to eq(StateTransition.new(output_symbol1, direction1, state1)) }
  end

  describe 'eql?' do
    it { expect(StateTransitionGene.new(1, 2, 3)).to eq(StateTransitionGene.new(1, 2, 3)) }
    it { expect(StateTransitionGene.new(1, 2, 3)).not_to eq(StateTransitionGene.new(2, 2, 3)) }
    it { expect(StateTransitionGene.new(1, 2, 3)).not_to eq(StateTransitionGene.new(1, 3, 3)) }
    it { expect(StateTransitionGene.new(1, 2, 3)).not_to eq(StateTransitionGene.new(1, 2, 4)) }
    it { expect(StateTransitionGene.new(1, 2, 3)).not_to eq(8) }
  end

end