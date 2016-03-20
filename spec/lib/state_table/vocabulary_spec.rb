require 'rspec'
require_relative '../../../lib/constants'
require_relative '../../../lib/state_table/vocabulary'

describe Vocabulary do
  let(:nr_tested_examples) { 100 }
  let(:vocabulary) { Vocabulary.new(states.count, symbols) }
  let (:states_including_init) { Array.new(states) + [INIT_STATE] }
  let (:states_including_accept) { Array.new(states) + [ACCEPT_STATE] }
  let (:symbols_including_nil) { Array.new(symbols) + [nil] }

  context 'several states and symbols available' do
    let (:states) { [state1, state2] }
    let (:symbols) { [symbol1, symbol2] }
    let(:state1) { 0 }
    let(:state2) { 1 }
    let(:symbol1) { 1 }
    let(:symbol2) { 4 }

    describe 'get_direction' do
      it 'returns direction randomly' do
        results = nr_tested_examples.times.map { vocabulary.get_direction }.flatten.uniq
        expect(results).to match_array(DIRECTIONS)
      end
      it 'does not return specified direction' do
        results = nr_tested_examples.times.map { vocabulary.get_direction(RIGHT) }.flatten.uniq
        expect(results).to contain_exactly(LEFT, STAY)
      end
    end

    describe 'get_state_on_input' do
      it 'returns state randomly' do
        results = nr_tested_examples.times.map { vocabulary.get_state_on_input }.flatten.uniq
        expect(results).to match_array(states_including_init)
      end
      it 'does not return specified state' do
        results = nr_tested_examples.times.map { vocabulary.get_state_on_input(state1) }.flatten.uniq
        expect(results).to contain_exactly(state2, INIT_STATE)
      end
    end

    describe 'get_state_on_output' do
      it 'returns state randomly' do
        results = nr_tested_examples.times.map { vocabulary.get_state_on_output }.flatten.uniq
        expect(results).to match_array(states_including_accept)
      end
      it 'does not return specified state' do
        results = nr_tested_examples.times.map { vocabulary.get_state_on_output(state1) }.flatten.uniq
        expect(results).to contain_exactly(state2, ACCEPT_STATE)
      end
    end

    describe 'get_symbol_on_input' do
      it 'returns symbol randomly' do
        results = nr_tested_examples.times.map { vocabulary.get_symbol_on_input }.flatten.uniq
        expect(results).to match_array(symbols)
      end
      it 'does not return specified symbol' do
        results = nr_tested_examples.times.map { vocabulary.get_symbol_on_input(symbol2) }.flatten.uniq
        expect(results).to contain_exactly(symbol1)
      end
    end

    describe 'get_symbol_on_output' do
      it 'returns symbol randomly' do
        results = nr_tested_examples.times.map { vocabulary.get_symbol_on_output }.flatten.uniq
        expect(results).to match_array(symbols_including_nil)
      end
      it 'does not return specified symbol' do
        results = nr_tested_examples.times.map { vocabulary.get_symbol_on_output(symbol2) }.flatten.uniq
        expect(results).to contain_exactly(symbol1, nil)
      end
    end

    describe 'get_direction' do
      it 'returns direction randomly' do
        results = nr_tested_examples.times.map { vocabulary.get_direction }.flatten.uniq
        expect(results).to match_array(DIRECTIONS)
      end
      it 'does not return specified direction' do
        results = nr_tested_examples.times.map { vocabulary.get_direction(LEFT) }.flatten.uniq
        expect(results).to contain_exactly(RIGHT, STAY)
      end
    end
  end

  context 'one state and one symbol available' do
    let (:states) { [state1] }
    let (:symbols) { [symbol1] }
    let(:state1) { :A }
    let(:symbol1) { 1 }

    describe 'get_symbol_on_input' do
      it 'always returns same symbol' do
        results = nr_tested_examples.times.map { vocabulary.get_symbol_on_input }.flatten.uniq
        expect(results).to match_array(symbol1)
      end
      it 'does ignore symbol that should not be return' do
        results = nr_tested_examples.times.map { vocabulary.get_symbol_on_input(symbol1) }.flatten.uniq
        expect(results).to contain_exactly(symbol1)
      end
    end

    describe 'mutate' do
      it 'returns self when nr_states is equal' do
        mutation = vocabulary.mutate(states.count)
        expect(mutation).to be == vocabulary
      end

      it 'returns another vocabulary with more states when nr_states is not equal' do
        nr_states_difference = 3
        mutation = vocabulary.mutate(states.count + nr_states_difference)

        old_states = nr_tested_examples.times.map { vocabulary.get_state_on_input }.uniq
        new_states = nr_tested_examples.times.map { mutation.get_state_on_input }.uniq
        diff_states = new_states.reject { |e1| old_states.any? { |e2| e2 == e1 } }
        expect(diff_states.count).to eq(nr_states_difference)
      end

      it 'raises exception when nr_state is 0' do
        expect(lambda { vocabulary.mutate(0) }).to raise_error(StandardError)
      end
    end

  end

  context 'no states or symbols available' do
    let (:states) { [] }
    let (:symbols) { [] }

    describe 'get_state_on_input' do
      it 'always return init-state' do
        states = nr_tested_examples.times.map { vocabulary.get_state_on_input }.flatten.uniq
        expect(states).to contain_exactly(INIT_STATE)
      end
    end
  end
end