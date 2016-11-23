class OutputFile::Row
  attr_reader :row

  def initialize headers, data_hash
    @headers = headers
    @row = row_from_hash(data_hash)
  end

  def valid?
    @headers.length == @row.length
  end

  def row_from_hash hash
    row = []

    @headers.each do |header|
      raise 'A key must be present for all headers' unless hash.key?(header)
      value = hash[header]
      row << value
    end

    row
  end
end
