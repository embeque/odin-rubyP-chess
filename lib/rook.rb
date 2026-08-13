require_relative 'chess'

class Rook
  attr_accessor :black, :position

  include Chess

  def initialize(position, black: false)
    @black = black
    @position = position

    @symbol = 'R'
    @symbol = 'r' if black
  end

  def draw
    return "\u2656" unless black

    "\u265c"
  end

  def moves(board, pos = position)
    # position -> d4
    result = []
    move_diffs = [[0, -1], [0, 1], [-1, 0], [1, 0]]
    # row, col = pos.chars.reverse
    move_diffs.each do |diff|
      i, j = pos.chars.reverse
      loop do
        row = i
        col = j
        i = row.to_i + diff[0]
        j = column_name(col.ord + diff[1])

        break unless valid?(i) && valid?(j)

        piece = board[index(i)][index(j)]
        result << (j + i.to_s) if opponent(self, piece)
        break unless piece.nil?

        result << (j + i.to_s)
      end
    end
    result
  end
end

# board = [
#   [nil, nil, nil, nil, nil, nil, nil, nil],
#   [1, nil, nil, nil, nil, nil, nil, nil],
#   [nil, nil, nil, nil, nil, 1, nil, nil],
#   [nil, nil, nil, nil, nil, nil, nil, nil],
#   [nil, nil, 1, Rook, nil, nil, nil, nil],
#   [nil, nil, nil, 1, nil, nil, nil, nil],
#   [nil, nil, nil, nil, nil, 1, nil, nil],
#   [nil, nil, nil, nil, nil, nil, nil, nil]
# ]

# print Rook.new('d4').all_moves(board)
