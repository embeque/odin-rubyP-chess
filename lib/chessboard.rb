require_relative 'pawn'
require_relative 'king'
require_relative 'queen'
require_relative 'bishop'
require_relative 'knight'
require_relative 'rook'

# class of chess
class ChessBoard
  attr_accessor :board, :turn, :selected

  # , :castling, :enpassant, :draw_counter, :moves

  def initialize
    @board = Array.new(8) { Array.new(8, nil) }
    # set_fen
    @turn = 0
    @selected = nil

    # fen things
    @castling = 'KQkq'
    @enpassant = nil
    @draw_counter = 0
    @moves = 1
  end

  def change_fen(default = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR')
    while (mat = default.match(/[2-8]/))
      default.sub!(mat[0], '1' * mat[0].to_i)
    end
    default
  end

  def play
    loop do
      draw_board
      choice = ask("(select) \\ (save)\n> ")
      if choice == 'save'
        save_game
        return
      # elsif choice.include?('select')
      elsif choice == 'select'
        # location = choice.split[1].chars.map do |char|
        #   char.to_i
        # end
        from_pos = select_piece # selected piece is in 'selected' instance variable
        to_pos = get_move
        system 'clear'
        play_move(from_pos, to_pos)
        change_turn
      else
        puts 'Invalid Option, try again with valid option'
      end
    end
  end

  def change_turn
    @turn = 1 - turn
  end

  def play_move(from, to)
    from_row, from_col = from
    to_row, to_col = to
    @board[to_row][to_col] = board[from_row][from_col]
    @board[from_row][from_col] = nil
  end

  def get_valid_pos(message = 'Position: ')
    loop do
      move = ask(message).chars.map do |char|
        char.to_i - 1
      end
      return move if move.is_a?(Array) && move.length == 2

      puts 'Invalid position, try again'
    end
  end

  def get_move
    get_valid_pos('Where to move this piece: ')
  end

  def menu
    puts '-----MENU-----'
    puts '1. Start New Game'
    puts '2. Load Game'
    puts '3. Exit'

    choice = ask '> '
    if choice == '1'
      play
    elsif choice == '2'
      set_fen(load_fen)
      play
    end
    puts 'Exiting'
  end

  def draw_board
    1.upto(8) do |num|
      print "\t", num
    end
    puts nil
    1.upto(8) do |row|
      print row, "\t"
      board[row - 1].each do |value|
        if value.nil?
          print '0', "\t"
        else
          print value.draw, "\t"
        end
      end
      puts nil
    end
    1.upto(11) do |num|
      print '______'
    end
    puts nil
  end

  def ask(message = 'Input: ')
    print message
    gets.chomp
  end

  def select_piece
    piece = get_valid_pos('Which piece you want to select (give position like 11 row,column)')
    row, col = piece
    self.selected = board[row][col]
    return piece unless selected.nil?

    puts 'Nothing is selected, try again'

    select_piece
  end

  def unselect_piece
    self.selected = nil
  end

  def set_fen(fen = 'rnbqkbnr/pppppppp/11111111/11111111/11111111/11111111/PPPPPPPP/RNBQKBNR w KQkq - 0 1')
    board_fen = fen.split[0].split('/')

    board_fen.each.with_index do |str, row|
      str.chars.each_with_index do |char, col|
        # Rook
        if char.downcase == 'r'
          rook = if char == 'R'
                   Rook.new # white rook
                 else
                   Rook.new(black: true) # black rook
                 end
          @board[row][col] = rook
          next
        end

        # Knight
        if char.downcase == 'n'
          knight = if char == 'N'
                     Knight.new # white knight
                   else
                     Knight.new(black: true) # black knight
                   end
          @board[row][col] = knight
          next
        end

        # Bishop
        if char.downcase == 'b'
          bishop = if char == 'B'
                     Bishop.new # white bishop
                   else
                     Bishop.new(black: true) # black bishop
                   end
          @board[row][col] = bishop
          next
        end

        # Queen
        if char.downcase == 'q'
          queen = if char == 'Q'
                    Queen.new # white queen
                  else
                    Queen.new(black: true) # black queen
                  end
          @board[row][col] = queen
          next
        end

        # King
        if char.downcase == 'k'
          king = if char == 'K'
                   King.new # white king
                 else
                   King.new(black: true) # black king
                 end
          @board[row][col] = king
          next
        end

        # Pawn
        if char.downcase == 'p'
          pawn = if char == 'P'
                   Pawn.new # white pawn
                 else
                   Pawn.new(black: true) # black pawn
                 end
          @board[row][col] = pawn
          next
        end

        next unless char.match?(/\d/)

        # col += board_fen[col].to_i
        next
      end
      row += 1
    end
    # true
  end

  def get_fen
    result = ''

    @board.each do |row|
      row.each do |elem|
        if elem.is_a? Rook
          result << if elem.isBlack
                      'r'
                    else
                      'R'
                    end
          next
        end
        if elem.is_a? Knight
          result << if elem.isBlack
                      'k'
                    else
                      'K'
                    end
          next
        end
        if elem.is_a? Bishop
          result << if elem.isBlack
                      'b'
                    else
                      'B'
                    end
          next
        end
        if elem.is_a? Queen
          result << if elem.isBlack
                      'q'
                    else
                      'Q'
                    end
          next
        end
        if elem.is_a? King
          result << if elem.isBlack
                      'k'
                    else
                      'K'
                    end
          next
        end
        if elem.is_a? Pawn
          result << if elem.isBlack
                      'p'
                    else
                      'P'
                    end
          next
        end
        result << '1' if elem.nil?
      end
      result << '/'
    end

    result # not adding castling info and turns now
  end
end
# rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1
