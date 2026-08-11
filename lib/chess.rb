module Chess
  def symbol
    @symbol
  end

  def index(num)
    if num.is_a?(Integer) && num.between?(1, 8)
      return 8 - num
    elsif num.between?('a', 'h')
      return num.ord - 97
    end

    nil
  end

  def valid?(num)
    return num.between?(1, 8) if num.is_a? Integer

    num.between?('a', 'h')
  end

  def column_name(num)
    num.chr
  end
end
