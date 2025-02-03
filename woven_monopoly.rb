require_relative 'player'
require_relative 'board'
require_relative 'game'

game = Game.new("board.json", "rolls_1.json")
game.play
