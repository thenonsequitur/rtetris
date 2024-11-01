# frozen_string_literal: true

require 'active_support'
require 'debug'

require './model/coords'
require './model/board'
require './model/piece'
require './model/canvas'
require './model/game'
require './lib/key_press'
require './lib/string_colors'

begin
  KeyPress.disable_echo

  game = Game.new
  true while game.tick
ensure
  KeyPress.enable_echo
end
