require 'rspec'
require 'json'
require_relative '../board'
require_relative '../player'

RSpec.describe Board do
  let(:board_data) do
    [
      { name: "GO", type: "go" },
      { name: "The Burvale", price: 1, colour: "Brown", type: "property" },
      { name: "Fast Kebabs", price: 1, colour: "Brown", type: "property" },
      { name: "The Grand Tofu", price: 2, colour: "Red", type: "property" },
      { name: "Lanzhou Beef Noodle", price: 2, colour: "Red", type: "property" },
      { name: "Betty's Burgers", price: 3, colour: "Green", type: "property" },
      { name: "YOMG", price: 3, colour: "Green", type: "property" },
      { name: "Gami Chicken", price: 4, colour: "Blue", type: "property" },
      { name: "Massizim", price: 4, colour: "Blue", type: "property" }
    ]
  end

  let(:file_path) { "board.json" }
  let(:board) { Board.new(file_path) }
  let(:peter) { Player.new("Peter") }
  let(:billy) { Player.new("Billy") }

  before do
    allow(File).to receive(:read).with(file_path).and_return(JSON.dump(board_data))
  end

  describe "#initialize" do
    it "loads the board spaces from the JSON file" do
      expect(board.spaces).to be_an(Array)
      expect(board.spaces.length).to eq(9)
      expect(board.spaces.first[:name]).to eq("GO")
    end
  end

  describe "#get_space" do
    it "returns the correct space based on index" do
      expect(board.get_space(1)).to eq(board_data[1])
      expect(board.get_space(3)).to eq(board_data[3])
    end
  end

  describe "#buy_property" do
    it "allows a player to buy a property if they have enough money" do
      board.buy_property(peter, 1)
      expect(peter.money).to eq(15)
      expect(peter.properties).to include(board_data[1])
      expect(board.owner_of(1)).to eq(peter)
    end

    it "prevents buying a property that is already owned" do
      board.buy_property(peter, 1)
      board.buy_property(billy, 1)
      expect(board.owner_of(1)).to eq(peter)
      expect(billy.properties).to be_empty
    end

    it "does not allow buying a non-property space" do
      board.buy_property(peter, 0)
      expect(peter.money).to eq(16)
      expect(peter.properties).to be_empty
      expect(board.owner_of(0)).to be_nil
    end
  end

  describe "#owner_of" do
    it "returns the correct owner of a property" do
      board.buy_property(peter, 1)
      expect(board.owner_of(1)).to eq(peter)
    end

    it "returns nil for unowned properties" do
      expect(board.owner_of(2)).to be_nil
    end
  end

  describe "#owns_full_set?" do
    it "returns true if a player owns all properties of a colour set" do
      board.buy_property(peter, 1)
      board.buy_property(peter, 2)
      expect(board.owns_full_set?(peter, "Brown")).to be true
    end

    it "returns false if a player does not own all properties of a colour set" do
      board.buy_property(peter, 1)
      expect(board.owns_full_set?(peter, "Brown")).to be false
    end

    it "returns false if properties are split between players" do
      board.buy_property(peter, 1)
      board.buy_property(billy, 2)
      expect(board.owns_full_set?(peter, "Brown")).to be false
      expect(board.owns_full_set?(billy, "Brown")).to be false
    end
  end
end
