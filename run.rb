require 'gosu'
require './food'
require './herbavore'
require './game_window'

module ZOrder
  BACKGROUND, FOOD, HERBAVORE = *0..2
end

window = GameWindow.new
window.show
