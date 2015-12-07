class Code
  def initialize(source)
    @source = source
  end

  def eval
    Object.send(:eval, @source)
  end

  def is_valid?
    begin
      eval
      true
    rescue SyntaxError
      false
    end
  end
end