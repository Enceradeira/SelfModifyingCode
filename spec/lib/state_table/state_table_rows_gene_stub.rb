class StateTableRowsGeneStub
  attr_reader :rows
  attr_reader :mutated_rows

  def initialize(rows, mutated_rows)
    @rows = rows
    @mutated_rows = mutated_rows
  end

  public
  def mutate()
    StateTableRowsGeneStub.new(@mutated_rows, @mutated_rows)
  end

  def ==(other)
    self.class == other.class &&
        self.rows==other.rows &&
        self.mutated_rows==other.mutated_rows
  end

  alias_method :eql?, :==
end