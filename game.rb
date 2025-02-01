class Game
  def initialize(board_file, dice_file)
    @players = [
      Player.new("Peter"),
      Player.new("Billy"),
      Player.new("Charlotte"),
      Player.new("Sweedal")
    ]
    @board = Board.new(board_file)
    @dice_rolls = JSON.parse(File.read(dice_file))
    @current_turn = 0
  end
end
