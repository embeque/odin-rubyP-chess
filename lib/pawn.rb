require_relative 'chess'

class Pawn
  attr_accessor :double, :black, :position

  include Chess

  def initialize(position, black: false)
    @black = black
    @position = position
    @double = false
    @double = true if position.match?('2') || position.match?('7')
  end

  def draw
    return "\u2659" unless black

    "\u265f"
  end

  def all_moves(pos = position) # how to handle the descending of black pawns
    # position -> d4
    result = []
    move_diffs = [[1, 0]]
    move_diffs << [1, 0] if double
    i, j = pos.chars.reverse
    move_diffs.each do |diff|
      i = i.to_i + diff[0]
      j = column_name(j.ord + diff[1])

      next unless valid?(i) && valid?(j)

      result << (j + i.to_s)
    end
    result # an array with all valid moves on board
    # but how to handle if there is another piece
  end
end

print Pawn.new('d4').all_moves
