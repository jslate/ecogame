require 'gosu'
require 'gosui'
require './food'
require './herbivore'
require './game_window'
require './predator'

module ZOrder
  BACKGROUND, FOOD, HERBIVORE, MENU, TEXT = *0..4
end

window = GameWindow.new
window.show
