require 'awesome_print'
require 'countries'

class PrettyPrintTransform
  def process(row)
    ap row
    row
  end
end

class FilterByCountry
  attr_reader :iso_codes

  def initialize(iso_codes:)
    @iso_codes = iso_codes
  end

  def process(row)
    # Search country by alpha3 code
    country = ISO3166::Country.new(row[:country_id])

    # Some ids are not standard (i.e. AN for Netherlands Antilles)
    if country
      iso_alpha3 = country.alpha3
    else
      # Discard the row, as we can's use it
      return nil
    end

    # Discard rows from countries that aren't included
    iso_codes.include?(iso_alpha3) ? row : nil
  end
end

class FindOrCreatePerfil
  def process(row)
    perfil = Perfil.find_or_initialize_by numero: row[:profile_id] do |perfil|
      perfil.fecha = Date.today
      perfil.publico = true
      perfil.build_ubicacion y: row[:latitude], x: row[:longitude]
    end

    perfil.save!

    row[:perfil_id] = perfil.to_param
    row
  end
end
