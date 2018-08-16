# Validates and executes an import process based on a CSV file
# TODO Validate csv format, handle error messages

require 'etl/user_csv'

class Import
  include ActiveModel::Model

  attr_accessor :file, :user, :producer, :type_id, :license_id, :source, :contact

  def self.headers
    %w{
      user_profile_id
      user_layer_id
      latitude
      longitude
      country
      date
      source
      contact
      order
      type
      license
      designation
      top
      bottom
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
    # We could capture the profile ids and redirect to a list/index of Profiles
    # from Import controller
    Etl::UserCsv::Job.new.import! file.path, profile_attributes

    true
  rescue StandardError => e
    errors.add :base, e.message

    false
  end

  private

  # Filter attributes needed for Profile creation
  def profile_attributes
    {
      usuario: user,
      reconocedor_list: producer,
      type_id: type_id,
      license_id: license_id,
      source: source,
      contact: contact
    }
  end
end
