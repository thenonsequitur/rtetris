# frozen_string_literal: true

module KeyPress
  def self.disable_echo
    system('stty -echo')
  end

  def self.enable_echo
    system('stty echo')
  end

  def self.getkey
    return nil unless char = nextchar

    return char.chr if char >= 32

    case char
      when 9 then return 'tab'
      when 10 then return 'enter'
    end

    if char == 27
      char2 = nextchar
      char3 = nextchar
      char4 = nextchar

      return 'esc' unless char2

      if char2 == 79
        case char3
          when 80 then return 'f1'
          when 81 then return 'f2'
          when 82 then return 'f3'
          when 83 then return 'f4'
        end
      end

      if char2 == 91
        if char3 == 49
          case char4
            when 53 then return 'f5'
            when 55 then return 'f6'
            when 56 then return 'f7'
            when 57 then return 'f8'
          end
        end

        if char3 == 50
          case char4
            when 126 then return 'insert'

            when 48 then return 'f9'
            when 49 then return 'f10'
            when 52 then return 'f12'
          end
        end

        case char3
          when 51 then return 'delete'

          when 53 then return 'pageup'
          when 54 then return 'pagedown'

          when 72 then return 'home'
          when 70 then return 'end'

          when 65 then return 'up'
          when 66 then return 'down'
          when 67 then return 'right'
          when 68 then return 'left'
        end
      end
    end

    return nil
  end

  private

  def self.nextchar
    system('stty raw')
    char = STDIN.read_nonblock(1).ord rescue nil
    system('stty -raw')
    char
  end
end