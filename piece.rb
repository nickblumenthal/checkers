require './board'

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
  attr_reader :board, :color, :king, :pos
  def initialize(board, color, pos = nil)
    @board, @color, @pos = board, color, pos
  end

  def perform_slide(end_pos)
    if valid_slide?(end_pos)
    end
  end

  def perform_jump(end_pos)

  end

  private

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
      return MOVE_DIRS[:black] + MOVE_DIRS[:white]
    else
      return MOVE_DIRS[color]
    end
  end

  # Test to see if valid slide
  def valid_slide?(end_pos)
    possible_ends = move_dirs.map { |offset| [row + offset[0], col + offset[1]] }
    possible_ends.include?(end_pos)  && board[end_pos].empty?
  end
end
