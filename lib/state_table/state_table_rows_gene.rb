require_relative 'numeric_gene'
require_relative 'state_table_row_gene'

class StateTableRowsGene
# < Struct.new(
#     :rows, :nr_rows_gene)

  def initialize(nr_rows_gene, rows)
    @nr_rows_gene = nr_rows_gene
    @rows = rows

  end

  public
  attr_reader :rows
  class << self
    def create(nr_rows_gene=NumericGene.new(1))
      rows = nr_rows_gene.value.times.map { |_| StateTableRowGene.create }
      StateTableRowsGene.new(nr_rows_gene, rows)
    end
  end


end