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

  def play
    @dice_rolls.each do |roll|
      current_player = @players[@current_turn]
      current_player.move(roll, @board.spaces.size)
      space = @board.get_space(current_player.position)
      @current_turn = (@current_turn + 1) % @players.size
    end
  end  
end
