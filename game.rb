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
      if space[:type] == "property"
        handle_property_landing(current_player, current_player.position)
      elsif space[:type] == "go"
        current_player.money += 1
      end
      break if game_over?
      @current_turn = (@current_turn + 1) % @players.size
    end
    declare_winner
  end
  private
  def handle_property_landing(player, position)
    owner = @board.owner_of(position)
    if owner.nil?
      @board.buy_property(player, position)
    elsif owner != player
      rent = calculate_rent(position, owner)
      player.pay_rent(rent)
      owner.money += rent
    end
  end

  def calculate_rent(position, owner)
    space = @board.get_space(position)
    base_rent = space[:price]
    @board.owns_full_set?(owner, space[:colour]) ? base_rent * 2 : base_rent
  end

  def game_over?
    @players.any?(&:bankrupt?)
  end

  def declare_winner
    winner = @players.max_by { |player| [player.money, player.properties.size] }

    puts "✨ The winner is #{winner.name} with $#{winner.money} and #{winner.properties.size} properties!"
  
    @players.each do |p|
      puts "➡️  #{p.name} finished with $#{p.money} at position #{p.position}, owning #{p.properties.size} properties."
    end
  end
end
