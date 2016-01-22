class Cell

  attr_accessor :value

  def initialize(value)
    @value = value
  end

  def has_left?
    !@left.nil?
  end

  def left
    if @left.nil?
      @left = Cell.new(nil)
      @left.right = self
    end
    @left
  end

  def left=(cell)
    @left = cell
  end

  def has_right?
    !@right.nil?
  end

  def right
    if @right.nil?
      @right = Cell.new(nil)
      @right.left = self
    end
    @right
  end

  def right=(cell)
    @right = cell
  end
end
