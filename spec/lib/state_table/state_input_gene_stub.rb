class StateInputGeneStub
  private
  def initialize(value, mutated_value)
    @value = value
    @mutated_value = mutated_value
  end

  public
  def decode
    @value
  end

  def mutate
    StateInputGeneStub.new(@mutated_value, @mutated_value)
  end
end