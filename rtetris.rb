require 'active_support'

require './model/coords'
require './model/board'
require './model/piece'
require './model/game'
require './lib/screen'
require './lib/key'

Key.disable_echo

game = Game.new
true while game.tick

Key.enable_echo
