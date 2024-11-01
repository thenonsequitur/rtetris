# frozen_string_literal: true

      COLORS = %w[ red green brown blue magenta cyan bold ]

class Piece
  PIECES = [
    # I
    {
      offsets: [Coords.new(0, 0), Coords.new(-2, 0), Coords.new(-1, 0), Coords.new(1, 0)],
      color: 'bold'
    },
    # T
    {
      offsets: [Coords.new(0, 0), Coords.new(-1, 0), Coords.new(0, -1), Coords.new(0, 1)],
      color: 'magenta'
    },
    # Box
    {
      offsets: [Coords.new(0, 0), Coords.new(0, 1), Coords.new(1, 0), Coords.new(1, 1)],
      color: 'red'
    },
    # right L
    {
      offsets: [Coords.new(0, 0), Coords.new(0, -1), Coords.new(0, 1), Coords.new(1, 1)],
      color: 'green'
    },
    # left L
    {
      offsets: [Coords.new(0, 0), Coords.new(0, -1), Coords.new(0, 1), Coords.new(-1, 1)],
      color: 'cyan'
    },
    # right S
    {
      offsets: [Coords.new(0, 0), Coords.new(0, -1), Coords.new(1, 0), Coords.new(1, 1)],
      color: 'blue'
    },
    # left S
    {
      offsets: [Coords.new(0, 0), Coords.new(0, -1), Coords.new(-1, 0), Coords.new(-1, 1)],
      color: 'brown'
    }
  ]

  attr_accessor :position
  attr_reader :offsets
  attr_accessor :color

  def initialize(position, offsets: nil, color: nil)
    @position = position.dup

    if offsets
      @offsets = offsets.map(&:dup)
      @color = color
    else
      piece = PIECES[rand(PIECES.count)].map(&:dup).to_h
      @offsets = piece[:offsets]
      @color = piece[:color]
      rand(4).times { rotate }
    end

    enforce_bounds
  end

  def dup
    self.class.new(@position, offsets: @offsets, color: @color)
  end

  def rotate
    @offsets.each_with_index do |offset, i|
      @offsets[i].row, @offsets[i].col = offset.col, -offset.row
    end
  end

  def enforce_bounds
    (0...offset_coords.count).each do |index|
      @position.row = @position.row + 1 while offset_coords[index].row < 0
      @position.row = @position.row - 1 while offset_coords[index].row >= Board::ROWS
      @position.col = @position.col + 1 while offset_coords[index].col < 0
      @position.col = @position.col - 1 while offset_coords[index].col >= Board::COLS
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
