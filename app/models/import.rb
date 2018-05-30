require 'etl/user_csv'

# Validates and executes an import process based on a CSV file
# TODO Validate csv format, handle error messages
class Import
  attr_accessor :csv

  # FIXME Pass owner to Kiba Job
  def initialize(csv:, owner:)
    @csv = csv
    @owner = owner
  end

  def self.headers
    %w{
      user_profile_id
      user_layer_id
      latitude
      longitude
      country
      top
      bottom
      date
      bdws
      tceq
      cfvo
      ecec
      elco
      orgc
      phaq
      phkc
      clay
      silt
      sand
      wrvo
    }
  end

  def self.template
    CSV.generate headers: true, force_quotes: true do |csv|
      csv << self.headers
    end
  end

  def save
    Etl::UserCsv::Job.new.import! csv

    true
  rescue
    false
  end
end
