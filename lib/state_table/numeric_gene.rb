require_relative 'randomizer'
require 'bitarray'

NUMERIC_GENE_NR_BITS = 16

class NumericGene
  private
  def initialize(bits = nil)
    @bits = bits.nil? ? BitArray.new(NUMERIC_GENE_NR_BITS) : bits
  end

  public

  class << self
    def create(value=0)
      bits = BitArray.new(NUMERIC_GENE_NR_BITS)
      value.to_s(2).chars.reverse.map { |v| v.to_i }.each_with_index do |v, i|
        bits[i] = v
      end
      NumericGene.new(bits)
    end
  end

  def value
    power = 0
    value = 0
    @bits.each do |i|
      value = value + i * (2 ** power)
      power = power + 1
    end
    value
  end

  def mutate(vocabulary=nil)
    copy = BitArray.new(NUMERIC_GENE_NR_BITS)
    copy.each_with_index { |_, i| copy[i] = @bits[i] }

    modified_index = Randomizer.rand(NUMERIC_GENE_NR_BITS-1)
    copy[modified_index] = copy[modified_index] == 1 ? 0 : 1

    NumericGene.new(copy)
  end
end