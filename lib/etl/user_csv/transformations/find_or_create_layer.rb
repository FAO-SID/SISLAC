# Finds or creates a Layer uniquely identified by its profile_layer_id
# (`tipo`).

require 'ap'

module Etl
  module UserCsv
    class FindOrCreateLayer
      # row comes with a `system_profile_id` id which we added while creating the Profile
      def process(row)
        profile = Perfil.find row[:system_profile_id]

        profile.horizontes.find_or_initialize_by user_layer_id: row[:user_layer_id] do |h|
          h.profundidad_superior = row[:top]
          h.profundidad_inferior = row[:bottom]
          h.tipo = row[:designation]

          h.build_analitico do |a|
            a.densidad_aparente = row[:bdws]
            a.ca_co3 = row[:tceq]
            a.gravas = row[:cfvo]
            a.t = row[:ecec]
            a.conductividad = row[:elco]
            a.carbono_organico_c = row[:orgc]
            a.ph_h2o = row[:phaq]
            a.ph_kcl = row[:phkc]
            a.arcilla = row[:clay]
            a.limo_2_50 = row[:silt]
            a.arena_total = row[:sand]
            a.agua_util = row[:wrvo]
          end
        end

        profile.save!

        row
      rescue ActiveRecord::RecordInvalid
        ap row

        raise
      end
    end
  end
end
