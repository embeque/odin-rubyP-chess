class Rook
  attr_accessor :black

  def initialize(black: false)
    @black = black
  end

  def draw
    return "\u2656" unless black

    "\u265c"
  end
end
