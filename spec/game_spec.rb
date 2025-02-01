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

  it "fetches board space after moving" do
    expect(game.instance_variable_get(:@board)).to receive(:get_space).at_least(:once)
    game.play
  end
  
end
