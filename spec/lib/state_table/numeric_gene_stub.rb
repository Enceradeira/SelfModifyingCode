class NumericGeneStub < Struct.new(
    :value, :mutated_value)

  def initialize(value, mutated_value)
    self.value = value
    self.mutated_value = mutated_value
  end

  def mutate(vocabulary)
    NumericGeneStub.new(self.mutated_value, self.mutated_value)
  end

  def decode
    self.value
  end

  def ==(other)
    self.class == other.class &&
        self.value==other.decode &&
        self.mutated_value==other.mutated_value
  end

  alias_method :eql?, :==

end