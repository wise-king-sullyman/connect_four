# frozen_string_literal: true

class Player
  def initialize(name, symbol)
    @name = name
    @symbol = symbol
  end

  def choose_column
    request_input
    player_input = gets.chomp
    until input_valid?(player_input)
      request_input
      player_input = gets.chomp
    end
    player_input.to_i - 1
  end

  def request_input
    puts 'Enter a number 1 - 7 to pick a column'
  end

  def input_valid?(input)
    input.to_i.between?(1, 7) ? true : false
  end
end