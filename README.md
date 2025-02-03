# Woven Monopoly

This is an implementation of the Woven Monopoly game in Ruby. The goal is to simulate a game of Monopoly with a fixed dice roll sequence and apply the game rules provided in the prompt.

## Project Overview

This project simulates a game of Woven Monopoly for four players: Peter, Billy, Charlotte, and Sweedal. Players take turns rolling dice and move around the board, purchasing properties, paying rent, and earning money when passing GO.

### Game Rules:
- The game follows standard Monopoly rules with slight modifications as described in the prompt.
- Players start with $16, and they take turns in the specified order: Peter, Billy, Charlotte, and Sweedal.
- Each player gets $1 for passing GO.
- Players must buy any unowned properties they land on and pay rent if the property is owned.
- Rent is doubled if a player owns all properties of the same color group.
- Once a player goes bankrupt, the remaining player with the highest money wins.

## Installation

1. Clone the repository:
   ```
   git clone https://github.com/muskaan2199/Woven_Monopoly.git
   cd Woven_Monopoly
   ```

## Running the Program
To run the game simulation, execute the following command:
```
ruby woven_monopoly.rb
```

## Expected Output:
- The winner of the game (based on the remaining money of all players).
- The final amount of money each player has.
- The spaces each player finished on.
- The number of properties each player has (tie breaker).

## Testing
To run tests for the project, I've used RSpec.  
Here’s how to run the tests:

Make sure you have rspec installed:
```
gem install rspec
```

Run the tests:
```
rspec
```
This will run all the tests defined in the `spec` directory and output the results to the terminal.

### Writing Tests:
- Tests are organized in the `spec` directory.
- Each component (such as player, property, board) has its own test file.
- You can add more test cases in the relevant spec files for further testing or edge cases.

## Design Decisions

### File Structure:
```
Woven_Monopoly/
│── woven_monopoly.rb      # Starting point: The main entry point that initiates the game
│── board.json             # JSON file containing the board configuration with property details
│── spec/                  # Directory containing all RSpec test files
│── board.rb               # Defines the Board class, managing property layout
│── README.md              # Project documentation
│── game.rb                # Main game logic: Handles game flow
│── player.rb              # Defines the Player class: Manages player-specific data 
│── rolls_1.json           # JSON file containing the first set of dice rolls
│── rolls_2.json           # JSON file containing the second set of dice rolls
```

### Extensibility:
The design allows for easy extensibility:
- Adding new game rules can be done by extending the `Game` class.
- New types of properties or special game rules (e.g., Chance cards, other board effects) can be added with minimal changes.
- Additional player actions can be added by extending the `Player` class.

### Approach:
I focused on clear separation of concerns between different components of the game:
- **Game**: Handles the flow of the game, turns, and overall rules.
- **Player**: Manages player-specific data such as money and position on the board.
- **Board**: Represents the Monopoly board and the properties on it.
```