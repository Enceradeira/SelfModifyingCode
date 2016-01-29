require 'rspec'
require_relative '../../lib/tape'

describe Tape do
  describe 'to_a' do
    let(:tape) { Tape.new(%w(3 2)) }
    it 'returns tape as array' do
      head = tape.create_head
      head.move :l
      head.move :l
      head.write :'9'
      head.move :l
      head.move :r
      head.move :r
      head.move :r
      head.move :r
      head.write :'1'
      head.move :r

      expect(tape.to_a).to eq([:'9', nil, :'3', :'1'])
    end
  end
  describe 'initialize' do
    it { expect(lambda { Tape.new([]) }).to raise_error StandardError }
    it { expect(lambda { Tape.new(nil) }).to raise_error StandardError }
  end
end