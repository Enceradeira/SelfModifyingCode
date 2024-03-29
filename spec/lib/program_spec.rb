require 'rspec'
require_relative 'source_repository'
require_relative '../../lib/program'

describe Program do
  let(:program) { Program.compile(source) }
  context 'when source empty' do
    let(:source) { [] }
    describe 'get_transition' do
      it 'returns nil' do
        expect(program.get_transition(nil, nil)).to be_nil
      end
    end
  end
  context "when source ['I,1->1,r,1']" do
    let(:source) { ['I,1->1,r,1'] }
    describe 'to_source' do
      it { expect(program.to_source).to eq(source) }
    end
    describe 'get_transition' do
      context 'when state is I and input 1' do
        it 'returns (1,r,1)' do
          expect(program.get_transition(:I, :'1')).to eq(StateTransition.new(:'1', :r, :'1'))
        end
      end
      context 'when state is O and input 1' do
        it 'returns nil' do
          expect(program.get_transition('O', 1)).to be_nil
        end
      end
      context 'when state is I and input 0' do
        it 'returns nil' do
          expect(program.get_transition('I', 0)).to be_nil
        end
      end
    end
  end
  context "when source ['I,1->1,,1']" do
    let(:source) { ['I,1->1,,1'] }
    describe 'to_source' do
      it { expect(program.to_source).to eq(source) }
    end
    describe 'get_transition' do
      context 'when state is I and input 1' do
        it 'returns (1,nil,1)' do
          expect(program.get_transition(:I, :'1')).to eq(StateTransition.new(:'1', nil, :'1'))
        end
      end
    end
  end
  context "when source ['I,1->,l,1']" do
    let(:source) { ['I,1->,l,1'] }
    describe 'to_source' do
      it { expect(program.to_source).to eq(source) }
    end
    describe 'get_transition' do
      context 'when state is I and input 1' do
        it 'returns (nil,l,1)' do
          expect(program.get_transition(:I, 1)).to eq(StateTransition.new(nil, :l, :'1'))
        end
      end
    end
  end
  context "when source [,->,r,continue']" do
    let(:source) { [',->,r,continue'] }
    describe 'to_source' do
      it { expect(program.to_source).to eq(source) }
    end
    describe 'get_transition' do
      it { expect(program.get_transition(:I, 1)).to eq(StateTransition.new(nil, :r, :continue)) }
      it { expect(program.get_transition(:A, 4)).to eq(StateTransition.new(nil, :r, :continue)) }
    end
  end
  context "when source [,0->,r,continue']" do
    let(:source) { [',0->,r,continue'] }
    describe 'to_source' do
      it { expect(program.to_source).to eq(source) }
    end
    describe 'get_transition' do
      it { expect(program.get_transition(:I, 0)).to eq(StateTransition.new(nil, :r, :continue)) }
      it { expect(program.get_transition(:FR, 0)).to eq(StateTransition.new(nil, :r, :continue)) }
      it { expect(program.get_transition(:B, 1)).to be_nil }
    end
  end
  context "when source [1,->,r,continue']" do
    let(:source) { ['1,->,r,continue'] }
    describe 'to_source' do
      it { expect(program.to_source).to eq(source) }
    end
    describe 'get_transition' do
      it { expect(program.get_transition(:'1', 0)).to eq(StateTransition.new(nil, :r, :continue)) }
      it { expect(program.get_transition(:'1', 1)).to eq(StateTransition.new(nil, :r, :continue)) }
      it { expect(program.get_transition(:Z, 1)).to be_nil }
    end
  end
  context 'when source for AND' do
    let(:source) { SourceRepository.and }
    describe 'to_source' do
      it { expect(program.to_source).to eq(source) }
    end
  end

  describe 'is_smaller_than?' do
    let(:small_program) { Program.compile %w(,->,r,continue a,->,r,continue a,b->,r,accept) }
    let(:large_program) { Program.compile %w(init,0->,r,undecided init,1->,r,true init,1->,r,true init,1->,r,true) }

    it { expect(small_program.is_smaller_than?(large_program)).to be_truthy }
    it { expect(large_program.is_smaller_than?(small_program)).to be_falsey }
  end
end