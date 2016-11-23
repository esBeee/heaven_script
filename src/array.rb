class Array
  def mean
    return nil if self.nil? || self.length == 0
    self.sum / self.length.to_f
  end

  def median
    return nil if self.nil? || self.length == 0

    element_index = self.length / 2
    self_sorted = self.sort

    if self.length % 2 == 0
      [self_sorted[element_index - 1], self_sorted[element_index]].mean
    else
      self.sort[element_index]
    end
  end

  def sum
    result = 0
    self.each { |value| result += value }
    result
  end

  def deviation
    median = self.median
    return nil if median.nil? || median == 0
    self.map { |value| (value - median) / median.to_f }.mean
  end
end
