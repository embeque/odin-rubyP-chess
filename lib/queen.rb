require_relative 'chess'

class Queen
  attr_accessor :black, :position

  include Chess

  def initialize(position = 'd1', black: false)
    @black = black
    position = 'd8' if black
    @position = position

    @symbol = 'Q'
    @symbol = 'q'
  end

  def draw
    return "\u2655" unless black

    "\u265b"
  end

  def moves(board, pos = position)
    # position -> d4
    result = []
    move_diffs = [[1, -1], [1, 0], [1, 1], [0, -1], [0, 1], [-1, -1], [-1, 0], [-1, 1]]
    # row, col = pos.chars.reverse
    move_diffs.each do |diff|
      i, j = pos.chars.reverse
      loop do
        row = i
        col = j
        i = row.to_i + diff[0]
        j = column_name(col.ord + diff[1])
        break unless valid?(i) && valid?(j)
        break unless board[index(i)][index(j)].nil?

        result << (j + i.to_s)
      end
    end
    result
  end
end

# board = [
#   [nil, nil, nil, nil, nil, nil, nil, nil],
#   [1, nil, nil, nil, nil, nil, 1, nil],
#   [nil, 1, nil, 1, nil, nil, nil, nil],
#   [nil, nil, 1, nil, nil, nil, nil, nil],
#   [nil, nil, 1, Queen, 1, nil, nil, nil],
#   [nil, nil, 1, 1, 1, nil, nil, nil],
#   [nil, 1, nil, nil, nil, nil, nil, nil],
#   [nil, nil, nil, nil, nil, nil, 1, nil]
# ]

# print Queen.new('d4').all_moves(board)
