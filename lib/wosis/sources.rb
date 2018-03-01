require 'csv'

class ProfilesCsvSource
  attr_reader :input_file

  def initialize(input_file)
    @input_file = input_file
  end

  def each
    CSV.open(input_file, headers: true, header_converters: :symbol, col_sep: "\t") do |csv|
      csv.each do |row|
        yield row.to_hash
      end
    end
  end
end
