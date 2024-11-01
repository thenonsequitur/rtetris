# frozen_string_literal: true

class Board
  ROWS = 20
  COLS = 10

  def initialize
    @state = Array.new(ROWS) { Array.new(COLS) }
  end

  def get(position)
    @state[position.row][position.col]
  end

  def collide?(piece)
    piece.offset_coords.any? do |offset|
      @state[offset.row][offset.col]
    end
  end

  def cement(piece)
    piece.offset_coords.each do |offset|
      @state[offset.row][offset.col] = true
    end
  end

  def complete_lines
    lines = 0

    0.upto(ROWS - 1) do |scan_row|
      if @state[scan_row].all?(true)
        scan_row.downto(1) do |collapse_row|
          @state[collapse_row] = @state[collapse_row - 1]
        end
        @state[0] = Array.new(COLS)

        lines += 1
      end
    end

    lines
  end
end
