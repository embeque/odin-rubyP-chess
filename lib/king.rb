require_relative 'chess'

class King
  attr_accessor :black, :position

  include Chess

  def initialize(position = 'e1', black: false)
    @black = black
    position = 'e8' if black
    @position = position
  end

  def draw
    return "\u2654" unless black

    "\u265a"
  end

  # will be called by `play move` function
  def all_moves(pos = position)
    # position -> d4
    result = []
    move_diffs = [[1, -1], [1, 0], [1, 1], [0, -1], [0, 1], [-1, -1], [-1, 0], [-1, 1]]
    row, col = pos.chars.reverse
    move_diffs.each do |diff|
      i = row.to_i + diff[0]
      j = column_name(col.ord + diff[1])

      next unless valid?(i) && valid?(j)

      result << (j + i.to_s)
    end
    result # an array with all valid moves on board
    # but how to handle if there is another piece
  end
end

print King.new.all_moves
