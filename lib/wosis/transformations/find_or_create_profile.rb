# Finds or creates a Profile uniquely identified based on its alphanumeric id
# (`numero`).
class FindOrCreateProfile
  attr_reader :release_date

  def initialize(release_date:)
    @release_date = release_date
  end

  def process(row)
    wosis_id = "WoSIS #{row[:profile_id]}"

    perfil = Perfil.find_or_initialize_by numero: wosis_id do |perfil|
      # FIXME Remove requirement of having a date in the Profile
      # FIXME Meanwhile, we use file release date.
      perfil.fecha = release_date

      # TODO Make Profiles public by default.
      perfil.publico = true

      perfil.build_ubicacion y: row[:latitude], x: row[:longitude]
    end

    perfil.save!

    row[:sislac_profile_id] = perfil.to_param
    row
  end
end
