class Queen
  attr_accessor :black

  def initialize(black: false)
    @black = black
  end

  def draw
    return "\u2655" unless black

    "\u265b"
  end
end
