class Player
  attr_accessor :name, :money, :position, :properties

  def initialize(name)
    @name = name
    @money = 16
    @position = 0
    @properties = []
  end

  def move(spaces, board_size)
    @position = (@position + spaces) % board_size
  end

  def buy_property(property)
    return unless @money >= property[:price]

    @money -= property[:price]
    @properties << property
  end

  def pay_rent(amount)
    @money -= amount
  end

  def bankrupt?
    @money <= 0
  end
end
