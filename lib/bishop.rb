require_relative 'chess'
class Bishop
  attr_accessor :black, :position

  include Chess

  def initialize(position, black: false)
    @black = black
    @position = position

    @symbol = 'B'
    @symbol = 'b' if black
  end

  def draw
    return "\u2657" unless black

    "\u265d"
  end

  # will be called by `play move` function
  def moves(board, pos = position)
    # position -> d4
    result = []
    move_diffs = [[1, 1], [-1, -1], [1, -1], [-1, 1]]
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
    result # an array with all valid moves on board
    # but how to handle if there is another piece
  end
end

# board = [
#   [nil, nil, nil, nil, nil, nil, nil, nil],
#   [1, nil, nil, nil, nil, nil, nil, nil],
#   [nil, nil, nil, nil, nil, 1, nil, nil],
#   [nil, nil, nil, nil,    nil, nil, nil, nil],
#   [nil, nil, nil, Bishop, nil, nil, nil, nil],
#   [nil, nil, nil, nil,    nil, nil, nil, nil],
#   [nil, nil, nil, nil, nil, 1, nil, nil],
#   [nil, nil, nil, nil, nil, nil, nil, nil]
# ]

# print Bishop.new('d4').moves(board)
