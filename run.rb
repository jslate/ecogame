require 'gosu'
require './food'
require './herbavore'
require './game_window'

module ZOrder
  BACKGROUND, FOOD, HERBAVORE, TEXT = *0..3
end

window = GameWindow.new
window.show
