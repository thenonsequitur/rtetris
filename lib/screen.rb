# frozen_string_literal: true

module Screen
  def self.clear
    print "\e[H\e[2J"
  end

  def self.display(board, score, lines, piece=nil)
    clear

    0.upto(Board::ROWS - 1).each do |row|
      print '|'
      0.upto(Board::COLS - 1).each do |col|
        cell = Coords.new(row, col)
        if piece && piece.offset_coords.any? { |offset_coord| offset_coord == cell }
          print '+'
        elsif board.get(cell)
          print '*'
        else
          print ' '
        end
      end
      print '|'
      puts
    end
    puts '|' + '-' * Board::COLS + '|'
    puts

    lines = "#{lines}"
    score = "#{score}"
    padding = ' ' * (Board::COLS + 2 - lines.length - score.length)

    puts "#{lines}#{padding}#{score}"
    puts
  end
end
