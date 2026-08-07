class King
  attr_accessor :black

  def initialize(black: false)
    @black = black
  end

  def draw
    return "\u2654" unless black

    "\u265a"
  end
end
