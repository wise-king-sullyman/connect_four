# frozen_string_literal: true

class Player
  attr_accessor :name, :symbol
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

class Board
  def initialize
    @grid = create_grid
  end

  def create_grid
    blank_grid = []
    7.times { blank_grid.push([]) }
    blank_grid.each { |row| 6.times { row.push(0) } }
  end

  def to_s
    output_string = ''
    @grid.transpose.each { |row| output_string += (row.to_s + "\n") }
    output_string
  end

  def update(column, symbol)
    empty_rows = @grid[column].count(0)
    return puts 'column full' if empty_rows.zero?

    @grid[column][empty_rows - 1] = symbol
  end
end