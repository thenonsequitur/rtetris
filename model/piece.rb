# frozen_string_literal: true

class Piece
  PIECES = [
    # I
    [Coords.new(0, 0), Coords.new(-2, 0), Coords.new(-1, 0), Coords.new(1, 0)],
    # T
    [Coords.new(0, 0), Coords.new(-1, 0), Coords.new(0, -1), Coords.new(0, 1)],
    # Box
    [Coords.new(0, 0), Coords.new(0, 1), Coords.new(1, 0), Coords.new(1, 1)],
    # right L
    [Coords.new(0, 0), Coords.new(0, -1), Coords.new(0, 1), Coords.new(1, 1)],
    # left L
    [Coords.new(0, 0), Coords.new(0, -1), Coords.new(0, 1), Coords.new(-1, 1)],
    # right S
    [Coords.new(0, 0), Coords.new(0, -1), Coords.new(1, 0), Coords.new(1, 1)],
    # left S
    [Coords.new(0, 0), Coords.new(0, -1), Coords.new(-1, 0), Coords.new(-1, 1)]
  ]

  attr_accessor :position
  attr_reader :offsets

  def initialize(position, offsets: nil)
    @position = position.dup

    if offsets
      @offsets = offsets.map(&:dup)
    else
      @offsets = PIECES[rand(PIECES.count)].map(&:dup)
      rand(4).times { rotate }
      enforce_bounds
    end
  end

  def dup
    self.class.new(@position, offsets: @offsets)
  end

  def rotate
    @offsets.each_with_index do |offset, i|
      @offsets[i].row, @offsets[i].col = offset.col, -offset.row
    end
  end

  def enforce_bounds
    @offsets.each do |offset|
      @position.row = @position.row + 1 while @position.row + offset.row < 0
      @position.row = @position.row - 1 while @position.row + offset.row >= Board::ROWS
      @position.col = @position.col + 1 while @position.col + offset.col < 0
      @position.col = @position.col - 1 while @position.col + offset.col >= Board::COLS
    end
  end

  def offset_coords
    coords = []
    @offsets.each do |offset|
      coords.push(Coords.new(@position.row + offset.row, @position.col + offset.col))
    end
    coords
  end
end
