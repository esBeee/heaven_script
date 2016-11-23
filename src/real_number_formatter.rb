class RealNumberFormatter

  def initialize value
    @value = value
  end

  # Returns the given value formatted as a decimal number.
  def decimal_number
    return nil_format if @value.nil?
    @value.to_f.to_s.gsub('.', ',')
  end


  private

  def nil_format
    '-'
  end
end
