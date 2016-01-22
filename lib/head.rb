require_relative 'cell'

class Head
  def initialize(cell)
    @cell = cell
  end

  def read
    @cell.value
  end

  def write(value)
    if @cell.nil?
      @cell = Cell.new(value)
    else
      @cell.value = value
    end
  end

  def move(direction)
    if direction == :r
      @cell = @cell.right
    elsif direction == :l
      @cell = @cell.left
    end
  end
end