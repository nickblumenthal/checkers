# encoding: utf-8
require './board'
require './piece'
require './kb_input'
require 'io/console'

# Game class, control running of the game
class Game
  include KBInput
  attr_reader :board
  def initialize
    @board = Board.new
  end

  def run
    until winner = board.winner
      turn(:black)
      turn(:white)
    end

    board_render([0, 0], "#{winner} won!")
  end

  def turn(color)
    begin
      board.render([0, 0], "Select the piece you wish to move")
      move_from = kb_select[:current_pos]
      raise InvalidMoveError.new("No piece selected") if board[move_from].nil?
      raise InvalidMoveError.new("Wrong Color") unless board[move_from].color == color
      board.render(move_from.dup,
                  "Select the moves you want to make ('m') and press enter when done",
                  [move_from.dup]
                )
      move_sequence = kb_select(move_from.dup)[:marked]
      raise InvalidMoveError.new("No moves marked") if move_sequence.empty?
      board[move_from].perform_moves(move_sequence)
    rescue InvalidMoveError => e
      board.render(move_from, "#{e.message}\nHit any key to continue")
      retry if STDIN.getch
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  g = Game.new
  g.run
end
