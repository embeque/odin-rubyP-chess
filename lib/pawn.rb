require_relative 'chess'

class Pawn
  attr_accessor :double, :black, :position, :direction

  include Chess

  def initialize(position, black: false)
    @direction = 1
    @direction = -1, 0 if black

    @symbol = 'P'
    @symbol = 'p' if black

    @black = black
    @position = position
    @double = true
    # @double = true if position.match?('2') || position.match?('7')
  end

  def draw
    return "\u2659" unless black

    "\u265f"
  end

  def moves(board, pos = position) # for en passant we can check the 'ChessBoard' class variable if it contain the same position as calculated then legal move and if nil or not the same position then not legal
    # position -> d4
    result = []
    move_diffs = [[direction, 0]]
    if double
      move_diffs << [direction, 0]
      @double = false
    end
    i, j = pos.chars.reverse
    move_diffs.each do |diff|
      i = i.to_i + diff[0]
      j = column_name(j.ord + diff[1])

      next unless valid?(i) && valid?(j)

      result << (j + i.to_s)
    end
    row, col = pos.chars.reverse
    kill_moves = [[direction, 1], [direction, -1]]
    kill_moves.each do |diff|
      i = row.to_i + diff[0]
      j = column_name(col.ord + diff[1])

      next unless valid?(i) && valid?(j)
      next if board[index(i)][index(j)].nil? # && enpassant

      result << (j + i.to_s)
    end
    result # an array with all valid moves on board
    # but how to handle if there is another piece
  end
end

board = [
  [nil, nil, nil, nil, nil, nil, nil, nil],
  [1, nil, nil, nil, nil, nil, nil, nil],
  [nil, nil, nil, nil, nil, 1, nil, nil],
  [nil, nil, nil, nil, nil, nil, nil, nil],
  [nil, nil, nil, nil, nil, nil, nil, nil],
  [nil, nil, nil, nil, Pawn, nil, nil, nil],
  [nil, nil, nil, Pawn, nil, 1, nil, nil],
  [nil, nil, nil, nil, nil, nil, nil, nil]
]

print Pawn.new('d2').moves(board)

# i can give a pawn position error when placed on first rank for white and 8th rank for black
