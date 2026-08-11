require_relative 'chess'

class King
  attr_accessor :black, :position

  include Chess

  def initialize(position = 'e1', black: false)
    @black = black
    position = 'e8' if black && position == 'e1'
    @position = position

    @symbol = 'K'
    @symbol = 'k' if black
  end

  def draw
    return "\u2654" unless black

    "\u265a"
  end

  # will be called by `play move` function
  def moves(board, pos = position)
    # position -> d4
    result = []
    move_diffs = [[1, -1], [1, 0], [1, 1], [0, -1], [0, 1], [-1, -1], [-1, 0], [-1, 1]]
    row, col = pos.chars.reverse
    move_diffs.each do |diff|
      i = row.to_i + diff[0]
      j = column_name(col.ord + diff[1])

      next unless valid?(i) && valid?(j)
      next unless board[index(i)][index(j)].nil?

      result << (j + i.to_s)
    end
    result # an array with all valid moves on board
    # but how to handle if there is another piece
  end
end

# board = [
#   [nil, nil, nil, nil, nil, nil, nil, nil],
#   [1, nil, nil, nil, nil, nil, nil, nil],
#   [nil, nil, nil, nil, nil, 1, nil, nil],
#   [nil, nil, nil, nil, nil, nil, nil, nil],
#   [nil, nil, nil, King, nil, nil, nil, nil],
#   [nil, nil, nil, nil, nil, nil, nil, nil],
#   [nil, nil, nil, nil, nil, 1, nil, nil],
#   [nil, nil, nil, nil, nil, nil, nil, nil]
# ]
# default position of king is available

# print King.new.moves(board)
