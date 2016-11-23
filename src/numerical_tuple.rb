class NumericalTuple

  def initialize value_1, value_2
    @value_1 = value_1
    @value_2 = value_2
  end

  # Returns the change rate from the first to the second value.
  def change_rate
    return nil if @value_1.nil? || @value_2.nil?

    if @value_1 == 0
      if @value_2 > 0
        return 1
      elsif @value_2 < 0
        return -1
      else
        return 0
      end
    end

    (@value_2 - @value_1) / @value_1.to_f
  end
end
