class NumberFormatter
  def initialize marketing_type, value
    @marketing_type = marketing_type
    @value = value
  end

  def round_50s_formatted_if_greater_than limes
    return nil if @value.nil?
    @value >= limes ? round_50s_formatted : nil
  end

  # Returns the current @value rounded to 50s, so, for example, 2326
  # becomes 2350, or 52 becomes 50. If @marketing_type is rent 23.26
  # becomes 23.5, for example.
  def round_50s_formatted
    return nil if @value.nil?

    if @marketing_type == :sell
      round_50s(@value)
    elsif @marketing_type == :rent
      @value.round(2)
      (round_50s(@value * 100) / 100.0).round(1)
    else
      raise 'Unknown marketing type: ' + @marketing_type.to_s
    end
  end

  def currency_formatted limes
    rounded_value = limes.nil? ? round_50s_formatted : round_50s_formatted_if_greater_than(limes)
    return '-' if rounded_value.nil? || rounded_value == 0

    "#{separate_by_comma(rounded_value)} €"
  end

  def percentage_formatted
    return '-' if @value.nil? || @value.abs >= 0.5

    rounded_value = (@value * 100).round

    return '-' if rounded_value == 0

    value_string = "#{rounded_value} %"
    value_string = "+#{value_string}" if rounded_value > 0
    value_string
  end


  private

  def separate_by_comma number_string
    raise 'How would I handle this shit?!' if number_string.nil?

    vor_komma, nach_komma = number_string.to_s.split('.')
    vor_komma_length = vor_komma.length

    i=1
    while (index = i * 3) < vor_komma_length
      vor_komma = vor_komma.insert(-1 * (index + i), '.')
      i += 1
    end

    nach_komma.nil? ? vor_komma : "#{vor_komma},#{nach_komma}"
  end

  def round_50s value
    rounded = value.round(-2)
    n = rounded - value

    if n < 0
      if n > -25
        rounded
      else
        rounded + 50
      end
    elsif n >= 0
      if n > 25
        rounded - 50
      else
        rounded
      end
    end
  end
end
