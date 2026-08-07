require_relative 'chess'

class Knight
  attr_accessor :black, :position

  include Chess

  def initialize(position, black: false)
    @black = black
    @position = position
  end

  def draw
    return "\u2658" unless black

    "\u265e"
  end

  # will be called by `play move` function
  def all_moves(pos = position)
    # position -> d4
    col, row = pos.chars
    result = []
    move_diffs = [[1, 2], [2, 1], [1, -2], [2, -1], [-1, -2], [-2, -1], [-2, 1], [-1, 2]]
    move_diffs.each do |diff|
      i = row.to_i + diff[0]
      j = column_name(col.ord + diff[1])
      result << (j + i.to_s) if valid?(i) && valid?(j)
    end
    result # an array with all valid moves on board
    # but how to handle if there is another piece
  end
end

# knight = Knight.new('b1')
# print knight.all_moves
