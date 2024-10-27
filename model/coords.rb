class Coords
  attr_accessor :row
  attr_accessor :col

  def initialize(row, col)
    @row, @col = row, col
  end

  def dup
    self.class.new(@row, @col)
  end

  def ==(other_coords)
    @row == other_coords.row && @col == other_coords.col
  end
end

