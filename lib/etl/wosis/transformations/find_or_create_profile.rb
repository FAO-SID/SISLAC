# Finds or creates a Profile uniquely identified based on its alphanumeric id
# (`numero`).
require 'ap'

module Etl
  module Wosis
    class FindOrCreateProfile
      attr_reader :release_date

      def initialize(release_date:)
        @release_date = release_date
      end

      def process(row)
        wosis_id = "WoSIS #{row[:profile_id]}"

        profile = Perfil.find_or_initialize_by numero: wosis_id do |profile|
          # FIXME Remove requirement of having a date in the Profile
          # FIXME Meanwhile, we use file release date.
          profile.fecha = release_date

          # TODO Make Profiles public by default.
          profile.publico = true

          profile.build_ubicacion y: row[:latitude], x: row[:longitude]
        end

        # FIXME Rewrite inside the block
        profile.country = row[:country_name]

        profile.save!

        row
      rescue ActiveRecord::RecordInvalid
        ap row

        raise
      end
    end
  end
end
