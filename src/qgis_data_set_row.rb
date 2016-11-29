class QgisDataSetRow

  def initialize data
    @data = data
  end

  def name
    @data[:name]
  end

  def sqm_price
    @data[:sqm_price]
  end

  def price
    @data[:price]
  end

  def down_at
    @data[:down_at]
  end

  def created_at
    @data[:created_at]
  end

  # Returns the difference between the created_at date and the down_at
  # date in days, or nil, if at least one of the dates is not given.
  def dwell_time
    return nil if created_at.nil? || down_at.nil?

    # Convert the created at Time to date.
    created_at_date = Date.new(
      created_at.year,
      created_at.month,
      created_at.day
    )

    (down_at - created_at_date).to_i.abs
  end
end
