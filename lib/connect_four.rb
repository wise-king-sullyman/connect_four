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
    puts "#{name} enter a number 1 - 7 to pick a column"
  end

  def input_valid?(input)
    input.to_i.between?(1, 7) ? true : false
  end
end

class Board
  attr_accessor :grid
  def initialize
    @grid = create_grid
  end

  def create_grid
    blank_grid = []
    7.times { blank_grid.push([]) }
    blank_grid.each { |row| 6.times { row.push('O') } }
  end

  def to_s
    output_string = " 1  2  3  4  5  6  7\n"
    @grid.transpose.each do |row|
      row.each do |char|
        output_string += (' ' + char.to_s + ' ')
      end
      output_string += "\n"
    end
    output_string
  end

  def update(column, symbol)
    empty_rows = @grid[column].count('O')
    return puts 'column full' if empty_rows.zero?

    @grid[column][empty_rows - 1] = symbol
  end
end

class Game
  def initialize
    @board = Board.new
    @players = [Player.new('player 1', '#'), Player.new('player 2', '@')]
    @winner = nil
  end

  def welcome
    puts 'Welcome to connect four!'
  end

  def end_message
    return puts 'Tie Game!' unless @winner.respond_to? :name

    puts "#{@winner.name} Won!"
  end

  def inline_win?(grid, player)
    grid.each do |row|
      symbol_counter = 0
      row.each do |char|
        char == player.symbol ? symbol_counter += 1 : symbol_counter = 0
        return true if symbol_counter == 4
      end
    end
    false
  end

  def column_win?(grid, player)
    inline_win?(grid, player)
  end

  def row_win?(grid, player)
    inline_win?(grid.transpose, player)
  end

  def diagonal_win?(grid, player)
    return true if inline_win?(shift_grid(grid, 1).transpose, player)

    inline_win?(shift_grid(grid, -1).transpose, player)
  end

  def shift_grid(grid, shift_direction)
    remove_rollovers(grid, shift_direction).map.with_index do |column, index|
      column.rotate(index * shift_direction)
    end
  end

  def remove_rollovers(grid, shift_direction)
    grid.map.with_index do |column, index|
      if shift_direction.negative?
        keep = column.first(6 - index)
        keep.push('O') until keep.size == 6
      else
        keep = column.last(6 - index)
        keep.unshift('O') until keep.size == 6
      end
      keep
    end
  end

  def tie_game?(grid)
    grid.each do |column|
      return false if column.include?('O')
    end
    true
  end

  def game_over(grid, player)
    if column_win?(grid, player) || row_win?(grid, player) || diagonal_win?(grid, player)
      player
    elsif tie_game?(grid)
      true
    else
      false
    end
  end

  def play
    welcome
    until @winner
      @players.each do |player|
        @board.update(player.choose_column, player.symbol)
        puts @board
        @winner = game_over(@board.grid, player)
        break if @winner
      end
    end
    end_message
    @winner
  end
end
