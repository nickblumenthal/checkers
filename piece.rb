require './board'
require './errors'
require 'matrix'
require 'byebug'

# Basic piece class
class Piece
  MOVE_DIRS = {
    :white => [
      [-1, -1],
      [-1, 1]
    ],
    :black => [
      [1, -1],
      [1, 1]
    ]
  }
  SYMBOLS = {
    :regular => { black: " ☻ ", white: " ☺ " },
    :king => { black: " ★ ", white: " ☆ "}
  }
  attr_reader :board, :color
  attr_accessor :pos, :king
  def initialize(board, color, pos = nil, king = false)
    @board, @color, @pos, @king = board, color, pos, king
  end

  def perform_slide(end_pos)
    raise InvalidMoveError.new('Invalid move') unless valid_slide?(end_pos)
    move_piece(end_pos)
    self.king = true if king_me?
  end

  def perform_jump(end_pos)
    raise InvalidMoveError.new('Invalid move') unless valid_jump?(end_pos)
    jumped_pos = find_jumped_pos(end_pos)
    board[jumped_pos] = nil
    move_piece(end_pos)
    self.king = true if king_me?
  end

  # Execute test move sequence
  def perform_moves!(move_sequence)
    if valid_jump?(move_sequence[0])
      move_sequence.each do |move|
        perform_jump(move)
      end
    elsif move_sequence.count == 1
      perform_slide(move_sequence[0])
    else
      raise InvalidMoveError.new('Invalid Move')
    end
  end

  # Execute real move sequence
  def perform_moves(move_sequence)
    if valid_move_seq?(move_sequence)
      perform_moves!(move_sequence)
    else
      raise InvalidMoveError.new('Invalid Move')
    end
  end

  # Test for valid move sequence
  def valid_move_seq?(move_sequence)
    dup_board = board.dup
    begin
      dup_board[pos].perform_moves!(move_sequence)
    rescue InvalidMoveError => e
      puts "#{e.message}"
      return false
    else
      return true
    end
  end

  # Test to see if valid slide
  def valid_slide?(end_pos)
    possible_ends = move_dirs.map { |dir| [row + dir[0], col + dir[1]] }
    possible_ends = possible_ends.map do |pos|
      pos if Board.on_board?(pos)
    end

    possible_ends.include?(end_pos) && board.empty?(end_pos)
  end

  # Test to see if valid jump
  def valid_jump?(end_pos)
    possible_ends = move_dirs.map { |dir| [row + 2 * dir[0], col + 2 * dir[1]] }
    possible_ends = possible_ends.map do |pos|
      pos if Board.on_board?(pos)
    end
    jumped_pos = find_jumped_pos(end_pos)

    # Valid jump if: right direction, empty landing spot, and jumped square has
    # a piece of the other color
    possible_ends.include?(end_pos) &&
      board.empty?(end_pos) &&
      board[jumped_pos] &&
      board[jumped_pos].color != color
  end

  # Find the location of the jumped checker piece
  def find_jumped_pos(end_pos)
    # Use vectors for easy math
    pos_v = Vector.elements(pos)
    end_v = Vector.elements(end_pos)
    jumped_pos = ((pos_v - end_v) / 2 + end_v).to_a

    jumped_pos
  end

  # Handle piece movement
  def move_piece(end_pos)
    board[end_pos] = self
    board[pos] = nil
    self.pos = end_pos
  end

  def dup(new_board)
    new_piece = Piece.new(new_board, color, pos, king)
  end

  # Helper method to return row position
  def row
    pos[0]
  end

  # Helper method to return col position
  def col
    pos[1]
  end

  # Return possible offset directions
  def move_dirs
    if king?
      return (MOVE_DIRS[:black] + MOVE_DIRS[:white])
    else
      return MOVE_DIRS[color]
    end
  end

  def king?
    king
  end

  def king_me?
    goal_row = (color == :black ? 7 : 0)
    goal_row == pos[0]
  end

  def get_symbol
    king? ? SYMBOLS[:king][color] : SYMBOLS[:regular][color]
  end

end
