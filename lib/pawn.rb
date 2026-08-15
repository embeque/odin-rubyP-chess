require_relative 'chess'
require_relative 'chessboard'
class Pawn
  attr_accessor :black, :position, :direction

  include Chess

  def initialize(position, black: false)
    @direction = 1
    @direction = -1 if black

    @symbol = 'P'
    @symbol = 'p' if black

    @black = black
    @position = position
    # @first_move = true if position.match?('2') || position.match?('7')
  end

  def draw
    return "\u2659" unless black

    "\u265f"
  end

  def moves(board, pos = position) # for en passant we can check the 'ChessBoard' class variable if it contain the same position as calculated then legal move and if nil or not the same position then not legal
    # also handle pawn promotion

    # position -> d4
    result = []
    move_diffs = [[direction, 0]]
    move_diffs << [direction, 0] if (pos.include?('2') && black == false) || (pos.include?('7') && black == true)
    i, j = pos.chars.reverse
    move_diffs.each do |diff|
      i = i.to_i + diff[0]
      j = column_name(j.ord + diff[1])

      next unless valid?(i) && valid?(j)
      break unless board[index(i)][index(j)].nil?

      result << (j + i.to_s)
    end
    row, col = pos.chars.reverse
    kill_moves = [[direction, 1], [direction, -1]]
    kill_moves.each do |diff|
      i = row.to_i + diff[0]
      j = column_name(col.ord + diff[1])

      next unless valid?(i) && valid?(j)

      result << (j + i.to_s) if ChessBoard.enpassant == j + i.to_s
      next if board[index(i)][index(j)].nil? # && enpassant

      result << (j + i.to_s)
    end

    # eligible = lambda do |char|
    #   char.include?('8')
    # end
    # promote if result.all?(eligible)

    result # an array with all valid moves on board
    # but how to handle if there is another piece
  end
end

# board = [
#   [nil, nil, nil, nil, nil, nil, nil, nil],
#   [1, nil, nil, nil, nil, nil, nil, nil],
#   [nil, nil, nil, nil, nil, 1, nil, nil],
#   [nil, nil, nil, nil, nil, nil, nil, nil],
#   [nil, nil, nil, nil, nil, nil, nil, nil],
#   [nil, nil, nil, nil, Pawn, nil, nil, nil],
#   [nil, nil, nil, Pawn, nil, 1, nil, nil],
#   [nil, nil, nil, nil, nil, nil, nil, nil]
# ]

# print Pawn.new('d8', black: true).moves(board)

# i can give a pawn position error when placed on first rank for white and 8th rank for black
