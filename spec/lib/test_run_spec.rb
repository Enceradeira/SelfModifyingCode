require 'rspec'
require_relative '../../lib/test_run'
require_relative 'test_case_stub'
require_relative 'program_fake'

describe TestRun do
  let(:machine_cycles_for_fast) { 56 }
  let(:machine_cycles_for_slow) { 4558 }
  let(:machine_cycles) { 256 }
  let(:slow_test_execution) { 567 }
  let(:large_program) { ProgramFake.new(123) }
  let(:small_program) { ProgramFake.new(10) }
  let(:program) { ProgramFake.new(56) }
  let(:resources) { Object.new }
  let(:test_run) { TestRun.new(program, test_cases, resources) }
  let(:test_cases_that_are_slow) { [
      TestCaseStub.new(false, machine_cycles_for_slow),
      TestCaseStub.new(false, machine_cycles_for_fast-1)] }
  let(:test_cases_that_are_fast) { [
      TestCaseStub.new(false, machine_cycles_for_fast),
      TestCaseStub.new(false, machine_cycles_for_fast+1)] }
  let(:test_cases_one_failing) { [
      TestCaseStub.new(false, machine_cycles),
      TestCaseStub.new(true, machine_cycles)] }
  let(:test_cases_two_failing) { [
      TestCaseStub.new(false, machine_cycles),
      TestCaseStub.new(false, machine_cycles)] }
  let(:test_cases_all_ok) { [TestCaseStub.new(true, machine_cycles)] }

  describe 'all_tests_ok?' do
    context 'when at least one tests fail' do
      let(:test_cases) { test_cases_one_failing }
      it { expect(test_run.all_tests_ok?).to be_falsey }
    end
    context 'when all tests ok' do
      let(:test_cases) { test_cases_all_ok }
      it { expect(test_run.all_tests_ok?).to be_truthy }
    end
  end

  describe 'is_better_than?' do
    context 'when program is correcter' do
      let(:better_test_run) { TestRun.new(large_program, test_cases_one_failing, resources) }
      let(:worse_test_run) { TestRun.new(small_program, test_cases_two_failing, resources) }
      it { expect(better_test_run.is_better_than?(worse_test_run)).to be_truthy }
      it { expect(worse_test_run.is_better_than?(better_test_run)).to be_falsey }
    end

    context 'when program uses fewer machine cycles' do
      let(:better_test_run) { TestRun.new(large_program, test_cases_that_are_fast, resources) }
      let(:worse_test_run) { TestRun.new(large_program, test_cases_that_are_slow, resources) }
      it { expect(better_test_run.is_better_than?(worse_test_run)).to be_truthy }
      it { expect(worse_test_run.is_better_than?(better_test_run)).to be_falsey }
    end

=begin
    context 'when program description is smaller' do
      let(:better_test_run) { TestRun.new(small_program, test_cases_two_failing, resources) }
      let(:worse_test_run) { TestRun.new(large_program, test_cases_two_failing, resources) }
      it { expect(better_test_run.is_better_than?(worse_test_run)).to be_truthy }
      it { expect(worse_test_run.is_better_than?(better_test_run)).to be_falsey }
    end
=end


    # context 'when program execution uses less tape' implement as needed
  end
end