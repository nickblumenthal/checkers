require './piece.rb'
require 'colorize'

# Board class
class Board
  attr_accessor :grid
  def initialize
    @grid = Array.new(8) { Array.new(8, nil) }
    setup_board
  end

  # Access board through brackets
  def [](pos)
    row, col = pos
    grid[row][col]
  end

  def []=(pos, value)
    row, col = pos
    grid[row][col] = value
  end

  # Create new board and pieces
  def setup_board
    odd, even = [[1, 3, 5, 7], [0, 2, 4, 6]]
    (0..2).each do |row_i|
      col = row_i.even? ? odd : even
      col.each do |col_i|
        pos = [row_i, col_i]
        self[pos] = Piece.new(self, :black, pos)
      end
    end

    (5..7).each do |row_i|
      col = row_i.even? ? odd : even
      col.each do |col_i|
        pos = [row_i, col_i]
        self[pos] = Piece.new(self, :white, pos)
      end
    end
  end

  # Return true if target position holds empty value (nil)
  def empty?(pos)
    board[pos].nil?
  end

  def inspect
    display = grid.map do |row|
      row.map do |piece|
        piece.nil? ? '     ' : piece.color
      end.join('|')
    end

    puts display
  end
end
