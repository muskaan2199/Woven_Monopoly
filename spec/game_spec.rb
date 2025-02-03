require 'rspec'
require 'json'
require_relative '../game'  
require_relative '../player'
require_relative '../board'

RSpec.describe Game do
  let(:board_file) { "fake_board.json" }
  let(:dice_file) { "fake_dice.json" }
  let(:board_data) { [{ "name" => "GO", "type" => "go" }, { "name" => "The Burvale", "type" => "property", "price" => 1 }] }
  let(:dice_rolls) { [2, 3, 5, 6] }
  let(:game) { Game.new(board_file, dice_file) }

  before do
    allow(File).to receive(:read).with(board_file).and_return(JSON.dump(board_data))
    allow(File).to receive(:read).with(dice_file).and_return(JSON.dump(dice_rolls))
  end

  describe "Initialization" do
    it "initializes with four players" do
      expect(game.instance_variable_get(:@players).map(&:name)).to eq(["Peter", "Billy", "Charlotte", "Sweedal"])
    end

    it "loads the board and dice rolls from file" do
      board = game.instance_variable_get(:@board)
      expect(board.spaces.first[:name]).to eq("GO")
      expect(game.instance_variable_get(:@dice_rolls)).to eq([2, 3, 5, 6])
    end
  end

  describe "#play" do
    it "moves players according to dice rolls" do
      players = game.instance_variable_get(:@players)

      players.each_with_index do |player, index|
        expect(player).to receive(:move).with(dice_rolls[index], board_data.size)
      end

      game.play
    end
  end

  describe "#calculate_rent" do
    let(:player) { double("Player", name: "Peter") }
    let(:property_position) { 1 }
    let(:property_space) { { type: "property", price: 5, colour: "Red" } }

    before do
      allow(game.instance_variable_get(:@board)).to receive(:get_space).with(property_position).and_return(property_space)
    end

    it "doubles the rent if the player owns the full set" do
      allow(game.instance_variable_get(:@board)).to receive(:owns_full_set?).with(player, "Red").and_return(true)
      expect(game.send(:calculate_rent, property_position, player)).to eq(10)
    end

    it "charges base rent if the player does not own the full set" do
      allow(game.instance_variable_get(:@board)).to receive(:owns_full_set?).with(player, "Red").and_return(false)
      expect(game.send(:calculate_rent, property_position, player)).to eq(5)
    end
  end

  describe "#handle_property_landing" do
    let(:player) { double("Player", name: "Peter", money: 10) }
    let(:owner) { double("Player", name: "Billy", money: 20) }
    let(:property_position) { 1 }
    let(:property_space) { { type: "property", price: 5, colour: "Red" } }

    before do
      allow(game.instance_variable_get(:@board)).to receive(:get_space).with(property_position).and_return(property_space)
    end

    it "calls buy_property if there is no owner" do
      allow(game.instance_variable_get(:@board)).to receive(:owner_of).with(property_position).and_return(nil)
      expect(game.instance_variable_get(:@board)).to receive(:buy_property).with(player, property_position)
      game.send(:handle_property_landing, player, property_position)
    end

    it "calls calculate_rent and makes player pay rent if property is owned" do
      allow(game.instance_variable_get(:@board)).to receive(:owner_of).with(property_position).and_return(owner)
      allow(game).to receive(:calculate_rent).with(property_position, owner).and_return(5)
      allow(player).to receive(:pay_rent).with(5)
      allow(owner).to receive(:money=)

      expect(game).to receive(:calculate_rent).with(property_position, owner)
      expect(player).to receive(:pay_rent).with(5)

      game.send(:handle_property_landing, player, property_position)
    end
  end

  describe "#game_over?" do
    before { allow(game).to receive(:check_bankruptcy) } 

    context "when no player is bankrupt" do
      it "returns false" do
        game.instance_variable_get(:@players).each { |player| allow(player).to receive(:bankrupt?).and_return(false) }
        expect(game.send(:game_over?)).to be false
      end
    end

    context "when a player is bankrupt" do
      it "returns true" do
        allow(game.instance_variable_get(:@players).first).to receive(:bankrupt?).and_return(true)
        expect(game.send(:game_over?)).to be true
      end
    end
  end

  describe "#declare_winner" do
  let(:players) do
    [
      double("Player", name: "Peter", money: 10, properties: [1, 2], position: 2),
      double("Player", name: "Billy", money: 20, properties: [3], position: 3),
      double("Player", name: "Charlotte", money: 15, properties: [4, 5], position: 4),
      double("Player", name: "Sweedal", money: 5, properties: [], position: 1)
    ]
  end

  before { game.instance_variable_set(:@players, players) }

  it "declares the correct winner based on money and property count" do
    winner = game.send(:determine_winner)  
    puts winner
    expect(winner.name).to eq("Billy")  
  end

  it "chooses player with more properties if money is tied" do
    players[1] = double("Player", name: "Billy", money: 15, properties: [3], position: 3)
    players[2] = double("Player", name: "Charlotte", money: 15, properties: [4, 5, 6], position: 4)
    
    game.instance_variable_set(:@players, players)
    winner = game.send(:determine_winner)
    expect(winner.name).to eq("Charlotte")  # Charlotte has more properties
  end

  it "chooses the first player in list if there's a complete tie" do
    players[0] = double("Player", name: "Billy", money: 15, properties: [1, 2], position: 2)
    players[1] = double("Player", name: "Peter", money: 15, properties: [3, 4], position: 3)
    
    game.instance_variable_set(:@players, players)
    winner = game.send(:determine_winner)
    expect(winner.name).to eq("Billy") 
  end
 end
end
