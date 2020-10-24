# frozen_string_literal: true

require_relative 'connect_four.rb'

quit_playing = false
until quit_playing
  game = Game.new
  game.play
  puts 'Quit Playing? y/n'
  player_input = gets.chomp
  quit_playing = true if player_input.downcase == 'y'
end
