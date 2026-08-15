require_relative 'chess'

class Knight
  attr_accessor :black, :position

  include Chess

  def initialize(position, black: false)
    @black = black
    @position = position

    @symbol = 'N'
    @symbol = 'n' if black
  end

  def draw
    return "\u2658" unless black

    "\u265e"
  end

  # will be called by `play move` function
  def moves(board, pos = position)
    # position -> d4
    col, row = pos.chars
    result = []
    move_diffs = [[1, 2], [2, 1], [1, -2], [2, -1], [-1, -2], [-2, -1], [-2, 1], [-1, 2]]
    move_diffs.each do |diff|
      i = row.to_i + diff[0]
      j = column_name(col.ord + diff[1])

      next unless valid?(i) && valid?(j)

      # this line must not be here because there is not trailing
      # next unless board[index(i)][index(j)].nil?
      piece = board[index(i)][index(j)]
      next unless opponent(self, piece) || piece.nil?

      result << (j + i.to_s)
    end
    result # an array with all valid moves on board
    # but how to handle if there is another piece
  end
end

# board = [
#   [nil, nil, nil, nil, nil, nil, nil, nil],
#   [1, nil, nil, nil, nil, nil, nil, nil],
#   [nil, nil, 1, nil, nil, nil, nil, nil],
#   [nil, nil, nil, nil, nil, 1, nil, nil],
#   [nil, nil, nil, Knight, nil, nil, nil, nil],
#   [nil, nil, nil, nil, nil, nil, nil, nil],
#   [nil, nil, nil, nil, 1, nil, nil, nil],
#   [nil, nil, nil, nil, nil, nil, nil, nil]
# ]

# print Knight.new('a1').moves(board)
