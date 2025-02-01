require 'rspec'
require_relative '../player'

RSpec.describe Player do
  let(:player) { Player.new("Peter") }
  let(:property) { { name: "The Burvale", price: 1, colour: "Brown", type: "property" } }

  describe "#initialize" do
    it "initializes with a name, $16, position 0, and no properties" do
      expect(player.name).to eq("Peter")
      expect(player.money).to eq(16)
      expect(player.position).to eq(0)
      expect(player.properties).to be_empty
    end
  end

  describe "#move" do
    it "moves the player and wraps around the board" do
      player.move(3, 9)
      expect(player.position).to eq(3)

      player.move(7, 9)
      expect(player.position).to eq(1)
    end
  end

  describe "#buy_property" do
    it "deducts money and adds property if affordable" do
      player.buy_property(property)
      expect(player.money).to eq(15)
      expect(player.properties).to include(property)
    end

    it "does not buy property if insufficient funds" do
      expensive_property = { name: "Gami Chicken", price: 20, colour: "Blue", type: "property" }
      player.buy_property(expensive_property)
      expect(player.money).to eq(16)
      expect(player.properties).to be_empty
    end
  end

  describe "#pay_rent" do
    it "deducts the rent from the player's money" do
      player.pay_rent(5)
      expect(player.money).to eq(11)
    end
  end

  describe "#bankrupt?" do
    it "returns false if player has money left" do
      expect(player.bankrupt?).to be false
    end

    it "returns true if player is out of money" do
      player.pay_rent(16)
      expect(player.bankrupt?).to be true
    end
  end
end
