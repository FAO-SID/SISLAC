# Finds or creates a Profile uniquely identified based on its alphanumeric id
# (`numero`).
require 'ap'

module Etl
  module Wosis
    class FindOrCreateProfile
      attr_reader :attributes

      def initialize(attributes)
        @attributes = attributes
      end

      def process(row)
        wosis_id = "WoSIS #{row[:profile_id]}"

        profile = Perfil.find_or_initialize_by numero: wosis_id do |profile|
          # TODO Make Profiles public by default.
          profile.publico = true

          profile.country = row[:country_name]

          profile.build_ubicacion y: row[:latitude], x: row[:longitude]
        end

        # Updates and tries to save the Profile with bulk defined attributes
        profile.update! attributes

        row
      rescue ActiveRecord::RecordInvalid
        ap row

        raise
      end
    end
  end
end
