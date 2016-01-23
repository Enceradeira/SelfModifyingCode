require 'rspec'
require_relative '../../lib/test_case'
require_relative 'source_repository'

describe TestCase do
  let(:and_program){Program.new(SourceRepository.and)}
  let(:or_program){Program.new(SourceRepository.or)}
  let(:erase_program){Program.new(SourceRepository.erase_tape)}
  let(:empty_program){Program.new(SourceRepository.empty)}
  describe 'test' do
    context '0,1->1' do
      let(:test_case) { TestCase.new('0,1->1') }
      it { expect(test_case.passes_for?(and_program)).to be_falsey }
      it { expect(test_case.passes_for?(or_program)).to be_truthy }
      it { expect(test_case.passes_for?(empty_program)).to be_falsey }
    end
    context '0,1->0' do
      let(:test_case) { TestCase.new('0,1->0') }
      it { expect(test_case.passes_for?(and_program)).to be_truthy }
      it { expect(test_case.passes_for?(erase_program)).to be_falsey }
      it { expect(test_case.passes_for?(or_program)).to be_falsey }
    end
    context 'A,C->' do
      let(:test_case) { TestCase.new('A,C->') }
      it { expect(test_case.passes_for?(and_program)).to be_falsey }
      it { expect(test_case.passes_for?(or_program)).to be_falsey }
      it { expect(test_case.passes_for?(erase_program)).to be_truthy }
    end
  end
end