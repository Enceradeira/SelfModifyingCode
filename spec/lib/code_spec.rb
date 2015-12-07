require 'rspec'
require_relative '../../lib/code'

describe Code do
  context 'when valid' do
    subject { Code.new('4*3') }
    it 'eval should evaluate' do
      expect(subject.eval).to eq(12)
    end
    it 'is_valid? should be true' do
      expect(subject.is_valid?).to be_truthy
    end
  end
  context 'when invalid' do
    subject { Code.new('4*^^^2') }
    it 'eval should throw exception' do
      expect(lambda{subject.eval}).to raise_error(SyntaxError)
    end
    it 'is_valid? should be false' do
      expect(subject.is_valid?).to be_falsey
    end
  end
end