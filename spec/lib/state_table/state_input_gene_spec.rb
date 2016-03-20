require 'rspec'
require_relative '../../../lib/state_table/state_input_gene'
require_relative '../../../lib/state_table/vocabulary'
require_relative '../../../lib/constants'
require_relative 'numeric_gene_stub'
require_relative '../symbols_stub'

describe StateInputGene do
  let(:vocabulary) { Vocabulary.new(states.count, symbols) }
  let(:states) { [] }
  let(:symbols) { SymbolsStub.new([], []) }
  let(:state1) { 0 }
  let(:state2) { 1 }
  let(:state3) { 2 }
  let(:input_symbol1) { 1 }
  let(:input_symbol2) { 4 }
  let(:input_symbol3) { -67 }

  describe 'decode' do
    let(:gene) { StateInputGene.new(state1, input_symbol1, vocabulary) }
    let(:states) { [state1] }
    let(:symbols) { SymbolsStub.new([input_symbol1], []) }
    it { expect(gene.decode).to be_a(StateInput) }
    it { expect(gene.decode).to eq(StateInput.new(state1, input_symbol1)) }
  end

  describe 'mutate' do
    let(:nr_tested_examples) { 50 }
    let(:gene) { StateInputGene.create(vocabulary) }
    let(:states) { [state1, state2, state3] }
    let(:symbols) { SymbolsStub.new([input_symbol1, input_symbol2, input_symbol3], [413]) }

    it 'mutates state sometimes' do
      mutated_states = nr_tested_examples.times.map { StateInputGene.create(vocabulary).mutate(vocabulary).decode.state }.uniq
      expect(mutated_states).to match_array(states.to_ary + [INIT_STATE])
    end

    it 'mutates symbol sometimes' do
      mutated_symbols = nr_tested_examples.times.map { StateInputGene.create(vocabulary).mutate(vocabulary).decode.symbol }.uniq
      expect(mutated_symbols).to match_array(symbols.for_input)
    end
    it 'mutates input or state but not both' do
      value = gene.decode
      what_changed_xor = nr_tested_examples.times.map do
        mutated_value = gene.mutate(vocabulary).decode
        has_state_changed = mutated_value.state != value.state
        has_symbol_changed = mutated_value.symbol != value.symbol
        has_state_changed ^ has_symbol_changed
      end.uniq
      expect(what_changed_xor).to contain_exactly(true)
    end
    it 'does not repeat states' do
      mutations = nr_tested_examples.times.reduce([gene]) { |genes| genes << genes.last.mutate(vocabulary) }.map { |g| g.decode }
      next_mutations = mutations.drop(1)
      state_mutations = mutations.zip(next_mutations).select do |e1, e2|
        !e2.nil? && e1.symbol == e2.symbol
      end
      state_always_changes = state_mutations.all? do |e1, e2|
        e1.state != e2.state
      end

      expect(state_always_changes).to be_truthy
    end
    it 'does not repeat symbols' do
      mutations = nr_tested_examples.times.reduce([gene]) { |genes| genes << genes.last.mutate(vocabulary) }.map { |g| g.decode }
      next_mutations = mutations.drop(1)
      state_mutations = mutations.zip(next_mutations).select do |e1, e2|
        !e2.nil? && e1.state == e2.state
      end
      state_always_changes = state_mutations.all? do |e1, e2|
        e1.symbol != e2.symbol
      end

      expect(state_always_changes).to be_truthy
    end
  end

  describe 'eql?' do
    it { expect(StateInputGene.new(state1, input_symbol2, vocabulary)).to eq(StateInputGene.new(state1, input_symbol2, vocabulary)) }
    it { expect(StateInputGene.new(state1, input_symbol2, vocabulary)).not_to eq(StateInputGene.new(state2, input_symbol2, vocabulary)) }
    it { expect(StateInputGene.new(state1, input_symbol2, vocabulary)).not_to eq(StateInputGene.new(state1, input_symbol1, vocabulary)) }
    it { expect(StateInputGene.new(state1, input_symbol2, vocabulary)).not_to eq(8) }
  end

end