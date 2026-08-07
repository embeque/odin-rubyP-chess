class Bishop
  attr_accessor :black

  def initialize(black: false)
    @black = black
  end

  def draw
    return "\u2657" unless black

    "\u265d"
  end
end
