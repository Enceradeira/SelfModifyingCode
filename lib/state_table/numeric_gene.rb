require_relative 'randomizer'
require 'bitarray'

NUMERIC_GENE_NR_BITS = 16

class NumericGene
  private
  def initialize(bits = nil)
    @bits = bits.nil? ? BitArray.new(NUMERIC_GENE_NR_BITS) : bits
  end

  public
  def value
    power = 0
    value = 0
    @bits.each do |i|
      value = value + i * (2 ** power)
      power = power + 1
    end
    value
  end

  def mutate
    copy = BitArray.new(NUMERIC_GENE_NR_BITS)
    copy.each_with_index { |_, i| copy[i] = @bits[i] }

    modified_index = Randomizer.rand(NUMERIC_GENE_NR_BITS-1)
    copy[modified_index] = copy[modified_index] == 1 ? 0 : 1

    NumericGene.new(copy)
  end
end