module Chess
  def valid?(num)
    return num.between?(1, 8) if num.is_a? Integer

    num.between?('a', 'h')
  end

  def column_name(num)
    num.chr
  end
end
