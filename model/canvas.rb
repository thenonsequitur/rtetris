# frozen_string_literal: true

class Canvas
  ROWS = `tput lines`.to_i - 1
  COLS = `tput cols`.to_i

  attr_reader :lines

  def initialize
    clear
  end

  def clear
    @lines = Array.new(ROWS, ' ' * COLS)
  end

  def draw_rectangle(row, col, lines)
    self.class.pad_lines(lines).each_with_index do |rect_line, rect_line_num|
      line_num = row + rect_line_num
      break if line_num >= ROWS

      left_slice = @lines[line_num].colorized_chars[0...col].join.to_s
      right_slice = @lines[line_num].colorized_chars[(col + rect_line.uncolorize.length)..].join.to_s
      @lines[line_num] = left_slice + rect_line + right_slice
    end
  end

  def display
    clear_screen_code = "\e[H\e[2J"
    print clear_screen_code

    @lines.each { |line| puts line }
  end

  def self.draw_border(lines)
    padded_lines = pad_lines(lines)

    boxed_lines = []
    boxed_lines << '┌' + ('─' * padded_lines.first.uncolorize.length) + '┐'
    boxed_lines += padded_lines.map { |line| '│' + line + '│' }
    boxed_lines << '└' + ('─' * padded_lines.first.uncolorize.length) + '┘'

    boxed_lines
  end

  private

  def self.pad_lines(lines)
    max_length = lines.map { |line| line.uncolorize.length }.max
    lines.map do |line|
      padding = ' ' * (max_length - line.uncolorize.length)
      line + padding
    end
  end
end
