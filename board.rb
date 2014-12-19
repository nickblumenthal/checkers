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

  def render(cursor_pos = [0, 0], message = '', marked = [])
    system("clear")
    display = grid.map.with_index do |row, row_i|
      row.map.with_index do |piece, col_i|
        if piece.nil?
          spot = '   '
          if (row_i + col_i).even?
            spot = spot.colorize(background: :red)
          end
        else
          spot = piece.get_symbol
        end
        spot = spot.colorize(background: :blue) if [row_i, col_i] == cursor_pos
        spot = spot.colorize(background: :yellow) if marked.include?([row_i, col_i])
        spot
      end.join('')
    end
    display.each_with_index do |row, i|
      display[i] = "#{i} |" + row
    end
    puts '    0  1  2  3  4  5  6  7'
    puts display
    puts message
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

  def winner
    return :white if grid.flatten.compact.none? { |piece| piece.color == :black }
    return :black if grid.flatten.compact.none? { |piece| piece.color == :white }

    nil
  end

  def mandatory_jumps(color)
    jump_end_pos = []
    pieces = all_pieces(color)
    pieces.each do |piece|
      jump_end_pos << find_end_jump(piece)
    end

    jump_end_pos
  end

  def find_end_jump(piece)
    #byebug
    answer = []
    offsets = piece.move_dirs
    possible_moves = offsets.map do |offset|
      [piece.row + 2* offset[0], piece.col + 2 * offset[1]]
    end
    valid_jumps = possible_moves.map { |move| move if piece.valid_jump?(move) }
    if valid_jumps.none?
      return piece.pos
    else
      valid_jumps.compact.each do |valid_jump|
        dup_board = self.dup
        dup_piece = dup_board[piece.pos]
        dup_piece.perform_moves([valid_jump])
        answer += dup_board.find_end_jump(dup_piece)
      end
    end

    answer
  end

  def all_pieces(color)
    grid.flatten.compact.select { |piece| piece.color == color }
  end
end
