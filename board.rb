require 'json'

# Class representing the game board, handling properties and ownership
class Board
  attr_reader :spaces

  # Initializes the board with spaces from a JSON file and sets up ownership tracking
  def initialize(file_path)
    @spaces = JSON.parse(File.read(file_path), symbolize_names: true)
    @ownership = {}
  end

  # Returns the space at the given index
  def get_space(index)
    @spaces[index]
  end

  # Allows a player to buy a property if it is available and unowned
  def buy_property(player, position)
    space = get_space(position)
    return unless space[:type] == "property"
    return if @ownership.key?(position)

    player.buy_property(space)
    @ownership[position] = player
  end

  # Returns the player who owns the property at the given position
  def owner_of(position)
    @ownership[position]
  end

  # Checks if the player owns all properties of a specific color (full set)
  def owns_full_set?(player, color)
    all_same_color = @spaces.select { |s| s[:type] == "property" && s[:colour] == color }
    owned_by_player = all_same_color.all? { |s| @ownership[@spaces.index(s)] == player }
    owned_by_player
  end
end
