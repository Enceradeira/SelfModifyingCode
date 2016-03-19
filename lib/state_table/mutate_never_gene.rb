class MutateNeverGene
  private
  def initialize(value)
    @value = value
  end

  public
  def mutate
    self
  end

  def decode
    @value
  end
end