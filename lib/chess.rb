module Chess
  def symbol
    @symbol
  end

  def opponent(one, two)
    return false if [one, two].any? { |elem| elem.nil? }
    return true if one.black != two.black

    false
  end

  def get_cordinates(string)
    row, col = string.chars.reverse
    [index(row.to_i), index(col)]
  end

  def get_position(cordinates)
    row, col = cordinates
    row = 8 - row
    (col + 97).chr + row.to_s
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
