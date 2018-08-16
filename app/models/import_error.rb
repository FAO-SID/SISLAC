# Show validation errors with the row that caused them

class ImportError < StandardError
  attr_reader :row

  def initialize(message, row)
    @row = row

    super I18n.t 'imports.error', message: message, row: row
  end
end
