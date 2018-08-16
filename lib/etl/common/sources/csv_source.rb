# Extract data from csv files one row at a time
require 'csv'

class CsvSource
  attr_reader :input_file, :opts

  def initialize(input_file, csv_options: { })
    @input_file = input_file
    @opts = default_options.merge csv_options
  end

  def each
    CSV.open(input_file, opts) do |csv|
      csv.each do |row|
        yield row.to_hash
      end
    end
  end

  def default_options
    {
      headers: true,
      header_converters: :symbol,
      col_sep: ',',
      encoding: 'utf-8'
    }
  end
end
