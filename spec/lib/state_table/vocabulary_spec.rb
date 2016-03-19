require 'rspec'
require_relative '../../../lib/constants'
require_relative '../../../lib/state_table/vocabulary'

describe Vocabulary do
  let(:nr_tested_examples) { 100 }
  let(:vocabulary) { Vocabulary.new(states, symbols) }
  let (:states_including_init) {Array.new(states) + [INIT_STATE]}

  context 'several states and symbols available' do
    let (:states) { [state1, state2] }
    let (:symbols) { [symbol1, symbol2] }
    let(:state1) { :A }
    let(:state2) { :B }
    let(:symbol1) { 1 }
    let(:symbol2) { 4 }

    describe 'get_state_randomly' do
      it 'returns state randomly' do
        results = nr_tested_examples.times.map { vocabulary.get_state_randomly }.flatten.uniq
        expect(results).to match_array(states_including_init)
      end
      it 'does not return specified state' do
        results = nr_tested_examples.times.map { vocabulary.get_state_randomly(state1) }.flatten.uniq
        expect(results).to contain_exactly(state2, INIT_STATE)
      end
    end

    describe 'get_symbol_randomly' do
      it 'returns symbol randomly' do
        results = nr_tested_examples.times.map { vocabulary.get_symbol_randomly }.flatten.uniq
        expect(results).to match_array(symbols)
      end
      it 'does not return specified symbol' do
        results = nr_tested_examples.times.map { vocabulary.get_symbol_randomly(symbol2) }.flatten.uniq
        expect(results).to contain_exactly(symbol1)
      end
    end
  end

  context 'one state and one symbol available' do
    let (:states) { [state1] }
    let (:symbols) { [symbol1] }
    let(:state1) { :A }
    let(:symbol1) { 1 }

    describe 'get_symbol_randomly' do
      it 'always returns same symbol' do
        results = nr_tested_examples.times.map { vocabulary.get_symbol_randomly }.flatten.uniq
        expect(results).to match_array(symbol1)
      end
      it 'does ignore symbol that should not be return' do
        results = nr_tested_examples.times.map { vocabulary.get_symbol_randomly(symbol1) }.flatten.uniq
        expect(results).to contain_exactly(symbol1)
      end
    end
  end
  context 'no states or symbols available' do
    let (:states) { [] }
    let (:symbols) { [] }

    describe 'get_state_randomly' do
      it 'always return init-state' do
        states = nr_tested_examples.times.map{ vocabulary.get_state_randomly}.flatten.uniq
        expect(states).to contain_exactly(INIT_STATE)
      end
    end
  end
end