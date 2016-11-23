#
# HEAVEN SCRIPT
# Written in Ruby 2.2.2
#
#
# Usage
# =====
#
# Assuming your input file is in the same folder as this file and it is
# named qgis_out_köln_sell_20161001.csv. Now, to receive the two output files
# carto.csv and checker.csv, simply open your terminal, navigate to this
# directory and run:
#
#   $ ruby heaven.rb qgis_out_köln_sell_20161001.csv
#
require 'csv'
require 'time'
require 'date'

require_relative './lib/colorize/lib/colorize.rb'

require_relative './src/array.rb'
require_relative './src/number_formatter.rb'
require_relative './src/real_number_formatter.rb'
require_relative './src/numerical_tuple.rb'
require_relative './src/output_file.rb'
require_relative './src/output_file/row.rb'
require_relative './src/qgis_data_set.rb'

reference_time = Time.now
reference_date = Date.today

puts ''
puts ''
puts ''
puts ''
puts ''
puts 'Welcome to '.light_white + 'HEAVEN'.light_cyan.italic + ' !'.light_white
puts ''
puts ''
puts ''
puts ''
puts ''

#
# 1.
#
# Read in the CSV file.

# Exit if no input file is given.
unless ARGV[0]
  puts ' ERROR '.red.swap
  puts ''
  puts 'Hell breaks loose if you don\'t provide the path to an input CSV file like: '.red
  puts ''
  puts '  $'.light_white + ' ruby heaven.rb qgis_out_köln_sell_20161001.csv'.red
  puts ''
  puts ''
  puts ''
  puts ''

  exit
end

# Get the path to the input file.
path_to_csv = ARGV[0].strip

puts ' 1 '.light_cyan.swap
puts ''
puts 'Starting to imbibe CSV file at '.light_white + path_to_csv.light_cyan + '.'.light_white

# Prepare input data.
in_data = []
marketing_type = nil
CSV.foreach(path_to_csv, col_sep: ',', headers: :first_row) do |row|
  print '.'.cyan

   data_row = {
    property_t: row['property_t'].to_sym,
    street: row['street'],
    zip_code: row['zip_code'],
    city: row['city'],
    latitude: row['latitude'].to_f,
    longitude: row['longitude'].to_f,
    living_spa: row['living_spa'].to_f,
    sqm_price: row['sqm_price'].to_f,
    created_at: Time.parse(row['created_at']),
    down_at: Date.parse(row['down_at']),
    name: row['name']
  }

  if row.key?('price')
    data_row[:price] = row['price'].to_i

    if marketing_type.nil?
      marketing_type = :sell
    elsif marketing_type != :sell
      raise 'This script does not support input files with mixed marketing types'
    end
  elsif row.key?('base_rent')
    data_row[:price] = row['base_rent'].to_f

    if marketing_type.nil?
      marketing_type = :rent
    elsif marketing_type != :rent
      raise 'This script does not support input files with mixed marketing types'
    end
  else
    raise 'Neither price nor base_rent available in input data'
  end

  in_data << data_row
end

if marketing_type.nil?
  raise 'Marketing type not set'
end

puts ''
puts 'That was it. I found '.light_white + in_data.length.to_s.light_cyan + ' holy rows of data in there. Moving on. Have faith!'.light_white
puts ''
puts ''
puts ''
puts ''
puts ''

#
# 2.
#
# Process the data.
puts ' 2 '.light_cyan.swap
puts ''
puts 'Changing water into wine. '.light_white + 'Oh Jesus'.light_cyan + ', our saviour!'.light_white
qgis_data_set = QgisDataSet.new(in_data)
out_data_checker = []
out_data_carto = []

qgis_data_set.distinct_names.each do |name|
  print '.'.cyan

  qgis_data_set_for_name = qgis_data_set.find_by_name(name)
  qgis_data_set_for_20142 = qgis_data_set_for_name.find_within_period(Date.new(2014, 7), Date.new(2015))
  qgis_data_set_for_20151 = qgis_data_set_for_name.find_within_period(Date.new(2015), Date.new(2015, 7))
  qgis_data_set_for_20152 = qgis_data_set_for_name.find_within_period(Date.new(2015, 7), Date.new(2016))
  qgis_data_set_for_20161 = qgis_data_set_for_name.find_within_period(Date.new(2016), Date.new(2016, 7))

  qgis_data_set_for_last_12_months = qgis_data_set_for_name.find_within_period(Date.new(reference_date.year - 1, reference_date.month), reference_date)
  qgis_data_set_for_last_last_12_months = qgis_data_set_for_name.find_within_period(Date.new(reference_date.year - 2, reference_date.month), Date.new(reference_date.year - 1, reference_date.month))

  out_data_checker << {
    name: name,
    Anz20142: qgis_data_set_for_20142.frequency,
    Anz20151: qgis_data_set_for_20151.frequency,
    Anz20152: qgis_data_set_for_20152.frequency,
    Anz20161: qgis_data_set_for_20161.frequency,
    Avg20142: qgis_data_set_for_20142.sqm_prices_mean,
    Avg20151: qgis_data_set_for_20151.sqm_prices_mean,
    Avg20152: qgis_data_set_for_20152.sqm_prices_mean,
    Avg20161: qgis_data_set_for_20161.sqm_prices_mean,
    Med20142: qgis_data_set_for_20142.sqm_prices_median,
    Med20151: qgis_data_set_for_20151.sqm_prices_median,
    Med20152: qgis_data_set_for_20152.sqm_prices_median,
    Med20161: qgis_data_set_for_20161.sqm_prices_median,
    Anz12lm: qgis_data_set_for_last_12_months.frequency,
    Anz12lmb: qgis_data_set_for_last_last_12_months.frequency,
    Avg12lm: qgis_data_set_for_last_12_months.sqm_prices_mean,
    Avg12lmb: qgis_data_set_for_last_last_12_months.sqm_prices_mean,
    Med12lm: qgis_data_set_for_last_12_months.sqm_prices_median,
    Med12lmb: qgis_data_set_for_last_last_12_months.sqm_prices_median,
    AvgChange: NumericalTuple.new(qgis_data_set_for_last_last_12_months.sqm_prices_mean, qgis_data_set_for_last_12_months.sqm_prices_mean).change_rate,
    MedChange: NumericalTuple.new(qgis_data_set_for_last_last_12_months.sqm_prices_median, qgis_data_set_for_last_12_months.sqm_prices_median).change_rate
  }

  # if name == 'Altstadt-Nord'
  #   puts qgis_data_set_for_20142.prices.inspect, qgis_data_set_for_20142.sqm_prices.inspect, qgis_data_set_for_20142.sqm_prices_mean
  # end
end

puts ''
puts 'CHECKER data prepared.'.light_white

out_data_checker.each do |out_data_checker_row|
  print '.'.cyan

  out_data_carto_row = {
    name: out_data_checker_row[:name],
    Avg12lm: NumberFormatter.new(marketing_type, out_data_checker_row[:Avg12lm]).round_50s_formatted_if_greater_than(6),
    Med12lm: NumberFormatter.new(marketing_type, out_data_checker_row[:Med12lm]).round_50s_formatted_if_greater_than(6),
    str_Avg12: NumberFormatter.new(marketing_type, out_data_checker_row[:Avg12lm]).currency_formatted(nil),
    str_Med12: NumberFormatter.new(marketing_type, out_data_checker_row[:Med12lm]).currency_formatted(nil),
    AvgChange: NumberFormatter.new(marketing_type, out_data_checker_row[:AvgChange]).percentage_formatted,
    MedChange: NumberFormatter.new(marketing_type, out_data_checker_row[:MedChange]).percentage_formatted,
    AvgChCol: out_data_checker_row[:AvgChange] && out_data_checker_row[:AvgChange] >= 0 ? '#f18825' : '#A8C3E7',
    MedChCol: out_data_checker_row[:MedChange] && out_data_checker_row[:MedChange] >= 0 ? '#f18825' : '#A8C3E7',
    Avg20142: NumberFormatter.new(marketing_type, out_data_checker_row[:Avg20142]).currency_formatted(3),
    Avg20151: NumberFormatter.new(marketing_type, out_data_checker_row[:Avg20151]).currency_formatted(3),
    Avg20152: NumberFormatter.new(marketing_type, out_data_checker_row[:Avg20152]).currency_formatted(3),
    Avg20161: NumberFormatter.new(marketing_type, out_data_checker_row[:Avg20161]).currency_formatted(3),
    Med20142: NumberFormatter.new(marketing_type, out_data_checker_row[:Med20142]).currency_formatted(3),
    Med20151: NumberFormatter.new(marketing_type, out_data_checker_row[:Med20151]).currency_formatted(3),
    Med20152: NumberFormatter.new(marketing_type, out_data_checker_row[:Med20152]).currency_formatted(3),
    Med20161: NumberFormatter.new(marketing_type, out_data_checker_row[:Med20161]).currency_formatted(3),
    Anz20142: out_data_checker_row[:Anz20142],
    Anz20151: out_data_checker_row[:Anz20151],
    Anz20152: out_data_checker_row[:Anz20152],
    Anz20161: out_data_checker_row[:Anz20161],
    Anz12lm: out_data_checker_row[:Anz12lm],
    Anz12lmb: out_data_checker_row[:Anz12lmb]
  }

  out_data_carto << out_data_carto_row
end

# Format CHECKER data.
out_data_checker.map! do |out_data_checker_row|
  out_data_checker_row.merge(
    Avg20142: RealNumberFormatter.new(out_data_checker_row[:Avg20142]).decimal_number,
    Avg20151: RealNumberFormatter.new(out_data_checker_row[:Avg20151]).decimal_number,
    Avg20152: RealNumberFormatter.new(out_data_checker_row[:Avg20152]).decimal_number,
    Avg20161: RealNumberFormatter.new(out_data_checker_row[:Avg20161]).decimal_number,
    Med20142: RealNumberFormatter.new(out_data_checker_row[:Med20142]).decimal_number,
    Med20151: RealNumberFormatter.new(out_data_checker_row[:Med20151]).decimal_number,
    Med20152: RealNumberFormatter.new(out_data_checker_row[:Med20152]).decimal_number,
    Med20161: RealNumberFormatter.new(out_data_checker_row[:Med20161]).decimal_number,
    Avg12lm: RealNumberFormatter.new(out_data_checker_row[:Avg12lm]).decimal_number,
    Avg12lmb: RealNumberFormatter.new(out_data_checker_row[:Avg12lmb]).decimal_number,
    Med12lm: RealNumberFormatter.new(out_data_checker_row[:Med12lm]).decimal_number,
    Med12lmb: RealNumberFormatter.new(out_data_checker_row[:Med12lmb]).decimal_number,
    AvgChange: RealNumberFormatter.new(out_data_checker_row[:AvgChange]).decimal_number,
    MedChange: RealNumberFormatter.new(out_data_checker_row[:MedChange]).decimal_number
  )
end

puts ''
puts 'CARTO data prepared.'.light_white

puts 'The data has been processed and is now '.light_white + 'ready to be chiseld in stone'.light_cyan + '.'.light_white
puts ''
puts ''
puts ''
puts ''
puts ''

input_file_name = path_to_csv.split('/').last
#
# 3.
#
# Create CHECKER file.
output_path = "./CHECKER_#{input_file_name}.csv"
headers = %i(name Anz20142 Anz20151 Anz20152 Anz20161 Avg20142 Avg20151 Avg20152 Avg20161 Med20142 Med20151 Med20152 Med20161 Anz12lm Anz12lmb Avg12lm Avg12lmb Med12lm Med12lmb AvgChange MedChange)
output_file = OutputFile.new(output_path, headers)
puts ' 3 '.light_cyan.swap
puts ''
puts 'Writing the sacred '.light_white + 'CHECKER'.light_cyan + ' file into '.light_white + output_path.light_cyan + '.'.light_white
output_file.add_rows(out_data_checker)
output_file.write!
print '.'.cyan

puts ''
puts 'The file you prayed for, for so long, '.light_white + 'now exists'.light_cyan + '.'.light_white
puts ''
puts ''
puts ''
puts ''
puts ''

#
# 4.
#
# Create CARTO file.
output_path = "./CARTO_#{input_file_name}.csv"
headers = %i(name Avg12lm Med12lm str_Avg12 str_Med12 AvgChange MedChange AvgChCol MedChCol Avg20142 Avg20151 Avg20152 Avg20161 Med20142 Med20151 Med20152 Med20161 Anz20142 Anz20151 Anz20152 Anz20161 Anz12lm Anz12lmb)
output_file = OutputFile.new(output_path, headers)
puts ' 4 '.light_cyan.swap
puts ''
puts 'Writing the holy '.light_white + 'CARTO'.light_cyan + ' file into '.light_white + output_path.light_cyan + '.'.light_white
output_file.add_rows(out_data_carto)
output_file.write!
print '.'.cyan

puts ''
puts 'The file that will save us all '.light_white + 'finally exists'.light_cyan + '.'.light_white
puts ''
puts ''
puts ''
puts ''
puts ''

#
# FIN
#
puts ' SALVATION '.light_cyan.swap
puts ''
puts 'Our journey ends here, my sheep.'.light_white
puts ''
puts ''
puts ''
puts ''
puts ''
