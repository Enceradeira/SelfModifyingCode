require 'rspec'
require_relative '../../lib/program'

describe Program do
  subject { Program.new(source) }
  context 'when source empty' do
    let(:source) { [] }
    describe 'get_transition' do
      it 'returns nil' do
        expect(subject.get_transition(nil, nil)).to be_nil
      end
    end
  end
  context "when source ['I,1->1,r,1']" do
    let(:source) { ['I,1->1,r,1'] }
    describe 'get_transition' do
      context 'when state is I and input 1' do
        it 'returns (1,r,1)' do
          expect(subject.get_transition('I', 1)).to eq(Transition.new('1', :r, '1'))
        end
      end
      context 'when state is O and input 1' do
        it 'returns nil' do
          expect(subject.get_transition('O', 1)).to be_nil
        end
      end
      context 'when state is I and input 0' do
        it 'returns nil' do
          expect(subject.get_transition('I', 0)).to be_nil
        end
      end
    end
  end
  context "when source ['I,1->1,-,1']" do
    let(:source) { ['I,1->1,-,1'] }
    describe 'get_transition' do
      context 'when state is I and input 1' do
        it 'returns (1,nil,1)' do
          expect(subject.get_transition('I', 1)).to eq(Transition.new('1', nil, '1'))
        end
      end
    end
  end
  context "when source ['I,1->,l,1']" do
    let(:source) { ['I,1->,l,1'] }
    describe 'get_transition' do
      context 'when state is I and input 1' do
        it 'returns (nil,l,1)' do
          expect(subject.get_transition('I', 1)).to eq(Transition.new(nil, :l, '1'))
        end
      end
    end
  end
end