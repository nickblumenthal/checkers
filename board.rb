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
    self[pos].nil?
  end

  def inspect
    display = grid.map.with_index do |row, row_i|
      row.map.with_index do |piece, col_i|
        spot = piece.nil? ? '     ' : piece.color
        spot.colorize(:background => :red) if (row_i + col_i).even?
        spot
      end.join('|')
    end
    display.each_with_index do |row, i|
      display[i] = "#{i} |" + row
    end
    puts '     0     1     2     3     4     5     6     7'
    puts display
  end

  # Class method to see if a position is on the playing board
  def self.on_board?(pos)
    pos.all? do |p|
      p.between?(0, 7)
    end
  end

  # Deep dup board
  def dup
    new_board = Board.new
    grid.each_with_index do |row, row_i|
      row.each_with_index do |piece, col_i|
        if piece.nil?
          new_board[[row_i, col_i]] = nil
        else
          new_board[[row_i, col_i]] = piece.dup(new_board)
        end
      end
    end
    new_board
  end
end
