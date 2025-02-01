require 'json'

class Board
  attr_reader :spaces

  def initialize(file_path)
    @spaces = JSON.parse(File.read(file_path), symbolize_names: true)
    @ownership = {}
  end

  def get_space(index)
    @spaces[index]
  end

  def buy_property(player, position)
    space = get_space(position)
    return unless space[:type] == "property"
    return if @ownership.key?(position)

    player.buy_property(space)
    @ownership[position] = player
  end

  def owner_of(position)
    @ownership[position]
  end

  def owns_full_set?(player, color)
    all_same_color = @spaces.select { |s| s[:type] == "property" && s[:colour] == color }
    owned_by_player = all_same_color.all? { |s| @ownership[@spaces.index(s)] == player }
    owned_by_player
  end
end
