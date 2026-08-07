class Pawn
  attr_accessor :double, :black

  def initialize(black: false)
    @black = black
    @double = true
  end

  def draw
    return "\u2659" unless black

    "\u265f"
  end
end
