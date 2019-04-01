require_relative 'player'
require_relative '../models/game_board'
require_relative '../models/counter'

# A player that uses the Command Line Interface
class CLIPlayer < Player
  def initialize(name, counter)
    super(name, counter)
  end

  def take_turn(board)
    loop do
      puts "Your turn.\nSelect option:"
      puts "Place [C]ounter\n[F]orfeit"
      input = gets.downcase.chomp
      if input == 'c'
        return PlayerAction::PLACE_COUNTER if place_counter board
      elsif input == 'f'
        puts 'Forfeiting.'
        return forfeit
      end
    end
  end

  def place_counter(board)
    loop do
      puts 'Enter column number: '
      # TODO: better input parsing
      input = gets.downcase.chomp
      return false if %w[b back].include? input

      col = input.to_i
      begin
        return board.place(@counter, col)
      rescue InvalidColumnError, ColumnFullError => error
        puts error
      end
    end
  end
end
