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

  let(:dice_rolls) { [2, 3, 5, 6, 1] }

  before do
    allow(File).to receive(:read).with(board_file).and_return(JSON.dump(board_data))
    allow(File).to receive(:read).with(dice_file).and_return(JSON.dump(dice_rolls))
  end

  it "initializes with four players" do
    game = Game.new(board_file, dice_file)
    expect(game.instance_variable_get(:@players).map(&:name)).to eq(["Peter", "Billy", "Charlotte", "Sweedal"])
  end

  it "loads the board from file" do
    game = Game.new(board_file, dice_file)
    board = game.instance_variable_get(:@board)
    expect(board.spaces.first[:name]).to eq("GO")
  end

  it "loads the dice rolls from file" do
    game = Game.new(board_file, dice_file)
    dice_rolls = game.instance_variable_get(:@dice_rolls)
    expect(dice_rolls).to eq([2, 3, 5, 6, 1])
  end
end
