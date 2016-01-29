require_relative 'cell.rb'
require_relative 'head.rb'


class Tape
  private
  def move_left(cell)
    if cell.has_left?
      move_left(cell.left)
    else
      cell
    end
  end

  def collect_right(cell)
    right = []
    if cell.has_right?
      right = collect_right(cell.right)
    end
    [cell.value] + right
  end

  public
  def initialize(content)
    if content.nil? || content.empty?
      raise StandardError 'Tape cannot be empty'
    end

    cells = content.map do |c|
      Cell.new(c.to_sym)
    end

    prev_cells = [nil] + cells
    next_cells = cells.drop(1)
    cells.zip(prev_cells.zip(next_cells)).each do |c|
      cell = c[0]
      left_right = c[1]
      cell.left = left_right[0]
      cell.right = left_right[1]
    end

    @initial_cell = cells[0]
  end

  def create_head
    Head.new(@initial_cell)
  end

  def to_a
    leftest_cell = move_left(@initial_cell)
    collect_right(leftest_cell).drop_while {|e| e.nil?}.reverse.drop_while {|e| e.nil?}.reverse
  end

end