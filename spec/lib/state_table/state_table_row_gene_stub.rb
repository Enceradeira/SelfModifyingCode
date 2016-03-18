class StateTableRowGeneStub
  private
  def initialize(value)
    @value = value
  end

  def ==(other)
    self.class == other.class &&
        self.value==other.value
  end
  alias_method :eql?, :==

  protected
  attr_reader :value

  public
  def decode
    @value
  end

end