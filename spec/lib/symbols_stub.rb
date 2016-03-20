class SymbolsStub
  private
  def initialize(input_symbols, output_symbols)
    @for_input = input_symbols
    @for_output = output_symbols
  end

  public
  attr_reader :for_input
  attr_reader :for_output
end