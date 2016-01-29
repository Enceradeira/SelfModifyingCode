require 'rspec'
require_relative '../../lib/head'
require_relative '../../lib/tape'

describe Head do
  let(:head) { tape.create_head }
  context 'when tape [1,3]' do
    let(:tape) { Tape.new(%w(1 3)) }
    describe 'move:l' do
      before { head.move :l }
      it { expect(head.read).to be_nil }
      describe 'move:l' do
        before { head.move :l }
        it { expect(head.read).to be_nil }
        describe 'move:r' do
          before { head.move :r }
          it { expect(head.read).to be_nil }
          describe 'move:r' do
            before { head.move :r }
            it { expect(head.read).to eq(:'1') }
            describe 'move:r' do
              before { head.move :r }
              it { expect(head.read).to eq(:'3') }
              describe 'move:l' do
                before { head.move :l }
                it { expect(head.read).to eq(:'1') }
              end
            end
          end
        end
      end
    end

    describe 'move:r' do
      before { head.move :r }
      it { expect(head.read).to eq(:'3') }
      describe 'move:r' do
        before { head.move :r }
        it { expect(head.read).to be_nil }
        describe 'move:r' do
          before { head.move :r }
          it { expect(head.read).to be_nil }
          describe 'move:l' do
            before { head.move :l }
            it { expect(head.read).to be_nil }
            describe 'move:l' do
              before { head.move :l }
              it { expect(head.read).to eq(:'3') }
              describe 'move:l' do
                before { head.move :l }
                it { expect(head.read).to eq(:'1') }
                describe 'move:l' do
                  before { head.move :l }
                  it { expect(head.read).to be_nil }
                end
              end
            end
          end
        end
      end
    end

    describe 'move:nil' do
      before { head.move nil }
      it { expect(head.read).to eq(:'1') }
    end
  end

  context 'when tape [7]' do
    let(:tape) { Tape.new(['7']) }
    describe 'write' do
      it 'writes value' do
        value = 'Hello'
        head.write(value)
        expect(head.read).to be(value)
      end
    end
  end
end