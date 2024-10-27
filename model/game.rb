class Game
  SPEED_MAX = 20.0
  SPEED_INCREASE_PER_LINE = 0.25

  def initialize
    @lines = 0
    @score = 0
    @speed = 0.0

    @board = Board.new
    @piece = spawn_piece
    @tick = 0
  end

  def tick
    sleep(1 / SPEED_MAX)
    @tick += 1

    if (key = Key.getkey)
      return false unless keypress(key)
    end

    piece_down if @tick % (SPEED_MAX - @speed).ceil == 0

    Screen.display(@board, @score, @lines, @piece)

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
      @score += 2 ** lines_completed
      @speed += lines_completed * SPEED_INCREASE_PER_LINE
      @speed = SPEED_MAX if @speed > SPEED_MAX
    end

    @piece = spawn_piece
  end
end
