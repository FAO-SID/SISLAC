# Finds or creates a Layer associated with a Profile, uniquely identified by
# its user_layer_id

require 'ap'

module Etl
  module UserCsv
    class FindOrCreateLayer
      # row comes with a `system_profile_id` id which we added while creating the Profile
      def process(row)
        profile = Perfil.find row[:system_profile_id]

        h = profile.horizontes.find_or_initialize_by user_layer_id: row[:user_layer_id]
        h.profundidad_superior = row[:top]
        h.profundidad_inferior = row[:bottom]
        h.tipo = row[:designation]

        h.save!

        a = h.analitico || h.build_analitico
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

        a.save!

        profile.save!

        row
      rescue ActiveRecord::RecordInvalid => e
        ap row

        raise ImportError.new e.message, row
      end
    end
  end
end
