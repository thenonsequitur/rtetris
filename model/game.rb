# frozen_string_literal: true

class Game
  FRAMES_PER_SECOND = 60

  MAX_SECONDS_PER_FALL = 1.0
  MIN_SECONDS_PER_FALL = 0.05
  SPEED_GRADATIONS = 100

  BOARD_CHAR = '▒'
  PIECE_CHAR = '▓'

  def initialize
    @lines = 0
    @score = 0
    @seconds_per_fall = MAX_SECONDS_PER_FALL

    @board = Board.new
    @piece = spawn_piece
    @next_piece = spawn_piece
    @tick = 0
  end

  def tick
    sleep(1.0 / FRAMES_PER_SECOND)
    @tick += 1

    if (key = KeyPress.getkey)
      return false unless keypress(key)
    end

    frames_per_fall = @seconds_per_fall * FRAMES_PER_SECOND
    piece_down if @tick % frames_per_fall.ceil == 0

    draw_canvas

    return false if @board.collide?(@piece)

    true
  end

  private

  def spawn_piece
    Piece.new(Coords.new(0, Board::COLS / 2))
  end

  def keypress(key)
    case key
    when 'esc', 'q'
      return false
    when 'up'
      piece_rotate
    when 'left'
      piece_left
    when 'right'
      piece_right
    when 'down'
      piece_down
    when ' '
      piece_drop
    end
    true
  end

  def piece_rotate
    rotated_piece = @piece.dup
    rotated_piece.rotate
    rotated_piece.enforce_bounds
    @piece = rotated_piece unless @board.collide?(rotated_piece)
  end

  def piece_left
    moved_piece = @piece.dup
    moved_piece.position.col -= 1
    moved_piece.enforce_bounds
    @piece = moved_piece unless @board.collide?(moved_piece)
  end

  def piece_right
    moved_piece = @piece.dup
    moved_piece.position.col += 1
    moved_piece.enforce_bounds
    @piece = moved_piece unless @board.collide?(moved_piece)
  end

  def piece_down
    moved_piece = @piece.dup
    moved_piece.position.row += 1
    moved_piece.enforce_bounds

    if moved_piece.position.row != @piece.position.row + 1 || @board.collide?(moved_piece)
      complete_lines
      false
    else
      @piece = moved_piece
      true
    end
  end

  def piece_drop
    true while piece_down
  end

  def complete_lines
    @board.cement(@piece)

    lines_completed = @board.complete_lines

    if lines_completed > 0
      @lines += lines_completed
      @score += 2 ** lines_completed - 1
      increase_speed(lines_completed)
    end

    @piece = @next_piece
    @next_piece = spawn_piece
  end

  def increase_speed(num_gradations)
    seconds_per_gradation = (MAX_SECONDS_PER_FALL - MIN_SECONDS_PER_FALL) / SPEED_GRADATIONS
    @seconds_per_fall -= num_gradations * seconds_per_gradation
    @seconds_per_fall = MIN_SECONDS_PER_FALL if @seconds_per_fall < MIN_SECONDS_PER_FALL
  end

  def draw_canvas
    game_elements_width = Board::COLS * 2 + 12
    left = ((Canvas::COLS - game_elements_width) / 2).to_i

    canvas = Canvas.new
    canvas.draw_rectangle(0, left, board_rect)
    canvas.draw_rectangle(0, left + board_rect.last.length + 2, stats_rect)
    canvas.display
  end

  def board_rect
    rect = []
    0.upto(Board::ROWS - 1).each do |row|
      rect_row = ''.dup
      0.upto(Board::COLS - 1).each do |col|
        cell = Coords.new(row, col)
        char = ' '
        if @piece.offset_coords.any? { |offset_coord| offset_coord == cell }
          char = PIECE_CHAR
        elsif @board.get(cell)
          char = BOARD_CHAR
        end
        rect_row += char * 2
      end
      rect << rect_row
    end

    rect = Canvas.draw_border(rect)
    rect.shift

    rect
  end

  def stats_rect
    rect = []

    anchor_row = @next_piece.offsets.map { |offset| offset.row }.min * -1
    anchor_col = @next_piece.offsets.map { |offset| offset.col }.min * -1

    next_piece_grid = Array.new(4) { Array.new(4, false) }
    @next_piece.offsets.each do |offset|
      next_piece_grid[anchor_row + offset.row][anchor_col + offset.col] = true
    end

    rect << 'LINES'
    rect << @lines.to_s
    rect << ''

    rect << 'SCORE'
    rect << @score.to_s
    rect << ''

    rect << 'NEXT'
    rect << ''
    next_piece_grid.each do |row|
      rect_row = ''.dup
      row.each do |cell|
        char = cell ? PIECE_CHAR : ' '
        rect_row += char * 2
      end
      rect << rect_row
    end

    rect
  end
end
