class QgisDataSet

  def initialize set
    @set = set
  end

  def distinct_names
    map { |row| row.name }.uniq
  end

  def frequency
    @set.length
  end

  def sqm_prices_mean
    sqm_prices.mean
  end

  def sqm_prices_median
    sqm_prices.median
  end

  def dwell_time_mean
    @dwell_time_mean ||= dwell_times.compact.mean
  end

  def dwell_time_median
    @dwell_time_median ||= dwell_times.compact.median
  end

  def dwell_times
    @dwell_times ||= map { |row| row.dwell_time }
  end

  def prices
    @prices ||= map { |row| row.price }
  end

  def sqm_prices
    @sqm_prices ||= map { |row| row.sqm_price }
  end

  # Finders.
  def find_by_name name
    data_with_name = select { |row| row.name == name }
    self.class.new(data_with_name)
  end

  def find_within_period period_start, period_end=nil
    result = find_younger_or_equal_than(period_start)

    if period_end
      result = result.find_older_than(period_end)
    end

    result
  end

  def find_younger_or_equal_than deadline
    data_within = select { |row| row.down_at >= deadline }
    self.class.new(data_within)
  end

  def find_older_than deadline
    data_within = select { |row| row.down_at < deadline }
    self.class.new(data_within)
  end

  def map
    @set.map do |row|
      yield(QgisDataSetRow.new(row))
    end
  end

  def select
    @set.select do |row|
      yield(QgisDataSetRow.new(row))
    end
  end
end
