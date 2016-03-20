require_relative 'numeric_gene'
require_relative 'state_table_rows_gene'
require_relative 'state_table_row'
require_relative 'state_transition'
require_relative 'mutation'

class Chromosome
  private
  def initialize(rows_gene)
    @rows_gene = rows_gene
  end

  protected
  attr_reader :rows_gene

  public
  class << self
    def create(symbols)
      Chromosome.new(StateTableRowsGene.create(symbols))
    end
  end

  def decode
    @rows_gene.decode
  end

  def mutate
    Chromosome.new(@rows_gene.mutate)
  end

  def ==(other)
    self.class == other.class &&
        @rows_gene==other.rows_gene
  end

  alias_method :eql?, :==
end