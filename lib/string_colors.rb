# frozen_string_literal: true

class String
  def black;          "\e[30m#{self}\e[0m" end
  def red;            "\e[31m#{self}\e[0m" end
  def green;          "\e[32m#{self}\e[0m" end
  def brown;          "\e[33m#{self}\e[0m" end
  def blue;           "\e[34m#{self}\e[0m" end
  def magenta;        "\e[35m#{self}\e[0m" end
  def cyan;           "\e[36m#{self}\e[0m" end
  def gray;           "\e[37m#{self}\e[0m" end

  def bg_black;       "\e[40m#{self}\e[0m" end
  def bg_red;         "\e[41m#{self}\e[0m" end
  def bg_green;       "\e[42m#{self}\e[0m" end
  def bg_brown;       "\e[43m#{self}\e[0m" end
  def bg_blue;        "\e[44m#{self}\e[0m" end
  def bg_magenta;     "\e[45m#{self}\e[0m" end
  def bg_cyan;        "\e[46m#{self}\e[0m" end
  def bg_gray;        "\e[47m#{self}\e[0m" end

  def bold;           "\e[1m#{self}\e[22m" end
  def italic;         "\e[3m#{self}\e[23m" end
  def underline;      "\e[4m#{self}\e[24m" end
  def blink;          "\e[5m#{self}\e[25m" end
  def reverse_color;  "\e[7m#{self}\e[27m" end

  def color_postfix_for_prefix(prefix)
    case prefix
      when "\e[1m" then "\e[22m"
      when "\e[3m" then "\e[23m"
      when "\e[4m" then "\e[24m"
      when "\e[5m" then "\e[25m"
      when "\e[7m" then "\e[27m"
      else "\e[0m"
    end
  end

  def uncolorize
    gsub(/\e\[\d+(;\d+)*m/, "")
  end

  def colorized_chars
    color_postfixes = ["\e[22m", "\e[23m", "\e[24m", "\e[25m", "\e[27m", "\e[0m"]

    processed = self.dup

    color_chars = []
    current_color_prefix = nil

    while processed.length > 0
      if processed =~ /^(\e\[\d+m)(.*)$/
        escape, processed = $1, $2
        if color_postfixes.include?(escape)
          current_color_prefix = nil
        else
          current_color_prefix = escape
        end
      else
        char = processed[0]
        processed = processed[1..]

        char = current_color_prefix + char if current_color_prefix
        char = char + color_postfix_for_prefix(current_color_prefix) if current_color_prefix

        color_chars << char
      end
    end

    color_chars
  end
end