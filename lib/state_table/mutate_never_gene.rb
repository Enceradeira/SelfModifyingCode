class MutateNeverGene
  private
  def initialize(value)
    @value = value
  end

  public
  def mutate(vocabulary=nil)
    self
  end

  def decode
    @value
  end
end