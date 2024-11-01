# frozen_string_literal: true

class Game
  FRAMES_PER_SECOND = 60

  MAX_SECONDS_PER_FALL = 0.10
  MIN_SECONDS_PER_FALL = 0.10
  SPEED_GRADATIONS = 50

  def initialize
    @lines = 0
    @score = 0
    @seconds_per_fall = MAX_SECONDS_PER_FALL

    @board = Board.new
    @piece = spawn_piece
    @tick = 0
  end

  def tick
    sleep(1.0 / FRAMES_PER_SECOND)
    @tick += 1

    if (key = Key.getkey)
      return false unless keypress(key)
    end

    frames_per_fall = @seconds_per_fall * FRAMES_PER_SECOND
    piece_down if @tick % frames_per_fall.ceil == 0

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
      increase_speed(lines_completed)
    end

    @piece = spawn_piece
  end

  def increase_speed(num_gradations)
    seconds_per_gradation = (MAX_SECONDS_PER_FALL - MIN_SECONDS_PER_FALL) / SPEED_GRADATIONS
    @seconds_per_fall -= num_gradations * seconds_per_gradation
  end
end
