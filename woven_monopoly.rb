require_relative 'player'
require_relative 'board'
require_relative 'game'

game = Game.new("board.json", "rolls3.json")
game.play
