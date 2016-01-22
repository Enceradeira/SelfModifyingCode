require 'rspec'
require_relative '../../lib/machine'
require_relative '../../lib/tape'

describe Machine do
  let(:machine) { Machine.new(tape, program) }
  describe 'execute' do
    context 'when program AND' do
      let(:program) { %w(
        init,0->,r,false
        init,1->,r,undecided
        false,0->0,-,accept
        false,1->0,-,accept
        undecided,0->0,-,accept
        undecided,1->1,-,accept) }
      context 'and input is valid' do
        context 'and input 00' do
          let(:tape) { %w(0 0) }
          it 'calculates 0' do
            expect(machine.execute).to eq(['0'])
          end
        end
        context 'when input 01' do
          let(:tape) { %w(0 1) }
          it 'calculates 0' do
            expect(machine.execute).to eq(['0'])
          end
        end
        context 'when input 11' do
          let(:tape) { %w(1 1) }
          it 'calculates 1' do
            expect(machine.execute).to eq(['1'])
          end
        end
        context 'when input 10' do
          let(:tape) { %w(1 0) }
          it 'calculates 0' do
            expect(machine.execute).to eq(['0'])
          end
        end
      end
    end
  end
end