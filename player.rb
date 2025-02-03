class Player
  # Initializes the player with a name, starting money, position, and an empty property list
  attr_accessor :name, :money, :position, :properties

  def initialize(name)
    @name = name
    @money = 16
    @position = 0
    @properties = []
  end

  # Moves the player by a given number of spaces on the board
  def move(spaces, board_size)
    @position = (@position + spaces) % board_size  
  end

  # Allows the player to buy a property if they have enough money
  def buy_property(property)
    return unless @money >= property[:price]

    @money -= property[:price]  
    @properties << property 
  end

  # Deducts the rent amount from the player's money when they land on an owned property
  def pay_rent(amount)
    @money -= amount  
  end

  # Checks if the player is bankrupt (i.e., has no money left)
  def bankrupt?
    @money <= 0  
  end
end
