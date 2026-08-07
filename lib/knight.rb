class Knight
  attr_accessor :black

  def initialize(black: false)
    @black = black
  end

  def draw
    return "\u2658" unless black

    "\u265e"
  end
end
