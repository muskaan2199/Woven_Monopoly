require 'rspec'
require 'json'
require_relative '../game'  
require_relative '../player'
require_relative '../board'

RSpec.describe Game do
  let(:board_file) { "fake_board.json" }
  let(:dice_file) { "fake_dice.json" }

  let(:board_data) do
    [
      { "name" => "GO", "type" => "go" },
      { "name" => "The Burvale", "type" => "property", "price" => 1 }
    ]
  end

  let(:dice_rolls) { [2, 3, 5, 6] }

  before do
    allow(File).to receive(:read).with(board_file).and_return(JSON.dump(board_data))
    allow(File).to receive(:read).with(dice_file).and_return(JSON.dump(dice_rolls))
  end

  let(:game) { Game.new(board_file, dice_file) }

  it "initializes with four players" do
    expect(game.instance_variable_get(:@players).map(&:name)).to eq(["Peter", "Billy", "Charlotte", "Sweedal"])
  end

  it "loads the board from file" do
    board = game.instance_variable_get(:@board)
    expect(board.spaces.first[:name]).to eq("GO")
  end

  it "loads the dice rolls from file" do
    dice_rolls = game.instance_variable_get(:@dice_rolls)
    expect(dice_rolls).to eq([2, 3, 5, 6])
  end


  it "moves players according to dice rolls" do
    expect(game.instance_variable_get(:@players).first).to receive(:move).with(2, board_data.size)
    expect(game.instance_variable_get(:@players)[1]).to receive(:move).with(3, board_data.size)
    expect(game.instance_variable_get(:@players)[2]).to receive(:move).with(5, board_data.size)
    expect(game.instance_variable_get(:@players)[3]).to receive(:move).with(6, board_data.size)
    game.play
  end

  it "doubles the rent if the player owns the full set of properties" do
    player = double("Player", name: "Peter")
    property_position = 1
    property_space = { type: "property", price: 5, colour: "Red" }
    allow(game.instance_variable_get(:@board)).to receive(:get_space).with(property_position).and_return(property_space)
    allow(game.instance_variable_get(:@board)).to receive(:owns_full_set?).with(player, "Red").and_return(true)
    rent = game.send(:calculate_rent, property_position, player)
    expect(rent).to eq(10)  
  end

  it "calls buy_property" do
    player = double("Player", name: "Peter", money: 10)
    owner = double("Player", name: "Billy", money: 20) 
    property_position = 1
    property_space = { type: "property", price: 5, colour: "Red" }
    allow(game.instance_variable_get(:@board)).to receive(:get_space).with(property_position).and_return(property_space)
    allow(game.instance_variable_get(:@board)).to receive(:owner_of).with(property_position).and_return(nil)
    expect(game.instance_variable_get(:@board)).to receive(:buy_property).with(player, property_position)
    game.send(:handle_property_landing, player, property_position)
  end

  it "calls calculate_rent and player pays rent" do
    player = double("Player", name: "Peter", money: 10)
    owner = double("Player", name: "Billy", money: 20) 
    property_position = 1
    property_space = { type: "property", price: 5, colour: "Red" }
    allow(game.instance_variable_get(:@board)).to receive(:get_space).with(property_position).and_return(property_space)
    allow(game.instance_variable_get(:@board)).to receive(:owner_of).with(property_position).and_return(owner)
    allow(game).to receive(:calculate_rent).with(property_position, owner).and_return(5)
    allow(player).to receive(:pay_rent).with(5)
    allow(owner).to receive(:money=) 
    expect(game).to receive(:calculate_rent).with(property_position, owner)
    expect(player).to receive(:pay_rent).with(5)
    game.send(:handle_property_landing, player, property_position)
  end

end
