require_relative 'chess'
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

  include Chess

  def initialize
    @board = Array.new(8) { Array.new(8, nil) }
    set_default_game
    @turn = 0
    # @selected = nil
    @win = nil

    # fen things
    @castling = 'KQkq'
    @@enpassant = nil
    @draw_counter = 0
    @moves = 1
  end

  def self.enpassant
    @@enpassant
  end

  def change_fen(default = 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR')
    while (mat = default.match(/[2-8]/))
      default.sub!(mat[0], '1' * mat[0].to_i)
    end
    default
  end

  def play
    main_menu
    choice = gets.chomp.to_i

    case choice
    when 1
      play_with_person
    when 2
      play_with_computer
    when 3
      load_game
      play_with_person
    end
  end

  def set_default_game
    default_fen = change_fen
    set_board_from_fen(default_fen)
    # other things are automatically initialized
  end

  def set_board_from_fen(fen)
    rows = fen.split('/')
    pieces = [Rook, Bishop, Knight, Queen, King, Pawn]

    rows.each_with_index do |row, ri|
      row.chars.each_with_index do |elem, ci|
        position = (ci + 97).chr + (8 - ri).to_s
        pieces.each do |piece|
          white = piece.new(position)
          black = piece.new(position, black: true)
          if white.symbol == elem
            @board[ri][ci] = white
            puts "white elem created on #{position} of piece #{piece}"
          elsif black.symbol == elem
            @board[ri][ci] = black
            puts "black elem created on #{position} of piece #{piece}"
          end
        end
      end
    end
  end

  def main_menu
    puts "\tMain Menu"
    puts nil
    puts '1- Play with Person'
    puts '2- Play with Computer'
    puts '3- Load Game'
    puts '4- Exit'
    puts nil
    print '> '
  end

  def play_with_person
    loop do
      system 'clear'
      draw_board
      person_move
      @moves += 1
      change_turn
      if @win
        game_over
        announce_winner
      end
    end
  end

  def person_move
    piece = nil
    loop do
      # choice = ask("Give the position of piece like d1 or enter 'exit' to stop playing")
      piece = select_piece # apna piece
      if piece.nil?
        puts 'Nothing is selected, try again'
        next
      end
      break if piece.black == false && turn.zero? # white's turn
      break if piece.black == true && turn == 1   # black's turn

      puts 'select your own piece ...'
    end
    move_piece(piece)
  end

  def choice_valid?(choice)
    choice.length == 2 && choice[0].between?('a', 'h') && choice[1].to_i.between?(1, 8)
  end

  def select_piece
    choice = ask("Give the position of piece like d1 or enter 'exit' to stop playing")
    # stop playing -> save and exit / don't save and exit
    stop_playing if choice == 'exit'
    unless choice_valid?(choice)
      puts 'Invalid choice, try again'
      return select_piece
    end
    row, col = get_cordinates(choice)
    board[row][col]
  end

  def move_piece(piece)
    position = piece.position
    choice = ask("Give the move for piece on #{position}")
    unless choice_valid?(choice)
      puts 'Invalid move, try again'
      return move_piece(piece)
    end
    unless piece.moves(board).include?(choice)
      puts 'Illegal Move, try selecting another piece'
      return person_move
    end
    enpassant_rules(piece, choice) if piece.is_a?(Pawn) && ChessBoard.enpassant == choice

    make_move(piece, choice)

    return unless piece.is_a? Pawn

    pawn_rules(position, piece, choice)
    @draw_counter = 0
  end

  def enpassant_rules(piece, choice)
    takepos = get_cordinates(choice)
    if piece.black == false
      takepos[0] += 1
    else
      takepos[0] -= 1
    end
    row, col = takepos
    @board[row][col] = nil
    @@enpassant = nil
  end

  def pawn_rules(position, piece, choice)
    # calculating when_enpassant logic
    if position.include?('2') && choice.include?('4')
      paspos = "#{position[0]}3"
      check_enpassant(piece, paspos)
    elsif position.include?('7') && choice.include?('5')
      paspos = "#{position[0]}6"
      check_enpassant(piece, paspos)
    elsif choice.include?('1')
      promote(choice, black = true)
    elsif choice.include?('8') # position[1] == '7' # i don't think this is that much useful
      promote(choice, black = false)
    end
  end

  def promote(choice, black)
    select = ask('To what you want to, promote your pawn? (r for rook), (n for knight), (b for bishop), (q for queen)').downcase
    promo = Queen
    case select
    when 'r'
      promo = Rook
    when 'b'
      promo = Bishop
    when 'n'
      promo = Knight
    else
      puts 'promoting to queen ...'
    end

    row, col = get_cordinates(choice)
    @board[row][col] = promo.new(choice, black: black)
  end

  def check_enpassant(piece, paspos)
    row, col = get_cordinates(piece.position)
    left = board[row][col - 1]
    @@enpassant = paspos if left.is_a?(Pawn) && opponent(left, piece)
    right = board[row][col + 1]
    return unless right.is_a?(Pawn) && opponent(right, piece)

    @@enpassant = paspos
  end

  def make_move(piece, choice)
    row, col = get_cordinates(piece.position)
    board[row][col] = nil

    row, col = get_cordinates(choice)
    board[row][col] = piece
    piece.position = choice
  end

  def change_turn
    @turn = 1 - turn
  end

  def draw_board
    tab_space_letters
    1.upto(8) do |row|
      print 9 - row, "\t"
      board[row - 1].each do |value|
        if value.nil?
          print '-', "\t"
        else
          print value.draw, "\t"
        end
      end
      puts nil
    end
    seperation_line
  end

  def seperation_line
    1.upto(11) do |num|
      print '______'
    end
    puts nil
  end

  def tab_space_letters
    97.upto(104) do |num|
      print "\t", num.chr
    end
    puts nil
  end

  def ask(message = '')
    puts message
    print '> '
    gets.chomp
  end
end

#   def play
#     loop do
#       draw_board
#       choice = ask("(select) \\ (save)\n> ")
#       if choice == 'save'
#         save_game
#         return
#       # elsif choice.include?('select')
#       elsif choice == 'select'
#         # location = choice.split[1].chars.map do |char|
#         #   char.to_i
#         # end
#         from_pos = select_piece # selected piece is in 'selected' instance variable
#         to_pos = get_move
#         system 'clear'
#         play_move(from_pos, to_pos)
#         change_turn
#       else
#         puts 'Invalid Option, try again with valid option'
#       end
#     end
#   end

#   def play_move(from, to)
#     from_row, from_col = from
#     to_row, to_col = to
#     @board[to_row][to_col] = board[from_row][from_col]
#     @board[from_row][from_col] = nil
#   end

#   def get_valid_pos(message = 'Position: ')
#     loop do
#       move = ask(message).chars.map do |char|
#         char.to_i - 1
#       end
#       return move if move.is_a?(Array) && move.length == 2

#       puts 'Invalid position, try again'
#     end
#   end

#   def get_move
#     get_valid_pos('Where to move this piece: ')
#   end

#   def menu
#     puts '-----MENU-----'
#     puts '1. Start New Game'
#     puts '2. Load Game'
#     puts '3. Exit'

#     choice = ask '> '
#     if choice == '1'
#       play
#     elsif choice == '2'
#       set_fen(load_fen)
#       play
#     end
#     puts 'Exiting'
#   end

#   def draw_board
#     1.upto(8) do |num|
#       print "\t", num
#     end
#     puts nil
#     1.upto(8) do |row|
#       print row, "\t"
#       board[row - 1].each do |value|
#         if value.nil?
#           print '0', "\t"
#         else
#           print value.draw, "\t"
#         end
#       end
#       puts nil
#     end
#     1.upto(11) do |num|
#       print '______'
#     end
#     puts nil
#   end

#   def ask(message = 'Input: ')
#     print message
#     gets.chomp
#   end

#   def select_piece
#     piece = get_valid_pos('Which piece you want to select (give position like 11 row,column)')
#     row, col = piece
#     self.selected = board[row][col]
#     return piece unless selected.nil?

#     puts 'Nothing is selected, try again'

#     select_piece
#   end

#   def unselect_piece
#     self.selected = nil
#   end

#   def set_fen(fen = 'rnbqkbnr/pppppppp/11111111/11111111/11111111/11111111/PPPPPPPP/RNBQKBNR w KQkq - 0 1')
#     board_fen = fen.split[0].split('/')

#     board_fen.each.with_index do |str, row|
#       str.chars.each_with_index do |char, col|
#         # Rook
#         if char.downcase == 'r'
#           rook = if char == 'R'
#                    Rook.new # white rook
#                  else
#                    Rook.new(black: true) # black rook
#                  end
#           @board[row][col] = rook
#           next
#         end

#         # Knight
#         if char.downcase == 'n'
#           knight = if char == 'N'
#                      Knight.new # white knight
#                    else
#                      Knight.new(black: true) # black knight
#                    end
#           @board[row][col] = knight
#           next
#         end

#         # Bishop
#         if char.downcase == 'b'
#           bishop = if char == 'B'
#                      Bishop.new # white bishop
#                    else
#                      Bishop.new(black: true) # black bishop
#                    end
#           @board[row][col] = bishop
#           next
#         end

#         # Queen
#         if char.downcase == 'q'
#           queen = if char == 'Q'
#                     Queen.new # white queen
#                   else
#                     Queen.new(black: true) # black queen
#                   end
#           @board[row][col] = queen
#           next
#         end

#         # King
#         if char.downcase == 'k'
#           king = if char == 'K'
#                    King.new # white king
#                  else
#                    King.new(black: true) # black king
#                  end
#           @board[row][col] = king
#           next
#         end

#         # Pawn
#         if char.downcase == 'p'
#           pawn = if char == 'P'
#                    Pawn.new # white pawn
#                  else
#                    Pawn.new(black: true) # black pawn
#                  end
#           @board[row][col] = pawn
#           next
#         end

#         next unless char.match?(/\d/)

#         # col += board_fen[col].to_i
#         next
#       end
#       row += 1
#     end
#     # true
#   end

#   def get_fen
#     result = ''

#     @board.each do |row|
#       row.each do |elem|
#         if elem.is_a? Rook
#           result << if elem.isBlack
#                       'r'
#                     else
#                       'R'
#                     end
#           next
#         end
#         if elem.is_a? Knight
#           result << if elem.isBlack
#                       'k'
#                     else
#                       'K'
#                     end
#           next
#         end
#         if elem.is_a? Bishop
#           result << if elem.isBlack
#                       'b'
#                     else
#                       'B'
#                     end
#           next
#         end
#         if elem.is_a? Queen
#           result << if elem.isBlack
#                       'q'
#                     else
#                       'Q'
#                     end
#           next
#         end
#         if elem.is_a? King
#           result << if elem.isBlack
#                       'k'
#                     else
#                       'K'
#                     end
#           next
#         end
#         if elem.is_a? Pawn
#           result << if elem.isBlack
#                       'p'
#                     else
#                       'P'
#                     end
#           next
#         end
#         result << '1' if elem.nil?
#       end
#       result << '/'
#     end

#     result # not adding castling info and turns now
#   end
# end
# # rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1
