# Finds or creates a Profile uniquely identified with a `user_profile_id`
# (stored in `numero` for now)
require 'ap'

module Etl
  module UserCsv
    class FindOrCreateProfile
      attr_accessor :owner

      def initialize(owner)
        @owner = owner
      end

      def process(row)
        profile = Perfil.find_or_initialize_by numero: row[:user_profile_id] do |profile|
          # FIXME Remove requirement of having a date in the Profile
          profile.fecha = row[:date] || Date.today

          profile.country = row[:country]

          # TODO Make Profiles public by default.
          profile.publico = true

          # Save current user as data owner
          profile.usuario = owner

          profile.build_ubicacion y: row[:latitude], x: row[:longitude]
        end

        profile.save!

        row[:system_profile_id] = profile.to_param

        row
      rescue ActiveRecord::RecordInvalid
        ap row

        raise
      end
    end
  end
end
