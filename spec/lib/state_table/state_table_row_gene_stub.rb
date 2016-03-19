class StateTableRowGeneStub
  private
  def initialize(value, mutated_value)
    @value = value
    @mutated_value = mutated_value
  end

  protected
  attr_reader :value

  public
  def decode()
    @value
  end

  def mutate
    self.class.new(@mutated_value, @mutated_value)
  end

  def ==(other)
    self.class == other.class &&
        self.value==other.value
  end

  alias_method :eql?, :==

end