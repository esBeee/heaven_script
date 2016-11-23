class OutputFile
  def initialize output_path, headers
    @headers = headers
    @output_path = output_path
    @rows = []
  end

  def add_rows array_of_hashes
    array_of_hashes.each { |hash| add_row(hash) }
  end

  def add_row hash
    csv_row = OutputFile::Row.new(@headers, hash)
    if csv_row.valid?
      @rows << csv_row.row
    else
      raise 'Did not expect any invalid rows'
    end
  end

  def write!
    CSV.open(@output_path, 'wb', col_sep: '|') do |csv|
      csv << @headers
      @rows.each { |row| csv << row }
    end
  end
end
