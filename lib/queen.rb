require_relative 'chess'

class Queen
  attr_accessor :black, :position

  include Chess

  def initialize(position = 'd1', black: false)
    @black = black
    position = 'd8' if black
    @position = position
  end

  def draw
    return "\u2655" unless black

    "\u265b"
  end

  def all_moves(pos = position)
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

        result << (j + i.to_s)
      end
    end
    result
  end
end

print Queen.new('d4').all_moves
