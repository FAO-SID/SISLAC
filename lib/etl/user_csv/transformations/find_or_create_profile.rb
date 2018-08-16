# Finds or creates a Profile uniquely identified with a combination of columns
# and updates it

require 'ap'

module Etl
  module UserCsv
    class FindOrCreateProfile
      attr_accessor :attributes

      def initialize(attributes)
        @attributes = attributes
      end

      def process(row)
        profile = Perfil.find_or_initialize_by uuid: uuid_from(row)

        # Assign global data
        profile.assign_attributes attributes

        # Overwrites global data
        profile.type = ProfileType.find_by(valor: row[:type]) if row[:type].present?
        profile.source = row[:source] if row[:source].present?
        profile.contact = row[:contact] if row[:contact].present?
        profile.license = License.find_by(acronym: row[:license]) if row[:license].present?
        profile.country = row[:country] if row[:country].present?

        profile.numero = row[:user_profile_id]

        # FIXME Remove requirement of having a date in the Profile
        profile.fecha = row[:date] || Date.today

        # TODO Make Profiles public by default.
        profile.publico = true

        profile.build_ubicacion y: row[:latitude], x: row[:longitude]

        profile.grupo = Grupo.find_or_create_by(descripcion: row[:order]) if row[:order].present?

        profile.save!

        # Preserve the generated Profile id within data row
        row[:system_profile_id] = profile.to_param

        row
      rescue ActiveRecord::RecordInvalid => e
        ap row

        raise ImportError.new e.message, row
      end

      # Generates a UUID for this profile with some key fields
      def uuid_from(row)
        key = [
          row[:country],
          row[:user_profile_id],
          row[:longitude],
          row[:latitude]
        ]

        Digest::MD5.hexdigest key.join
      end
    end
  end
end
