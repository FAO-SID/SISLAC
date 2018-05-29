# Finds or creates a Layer uniquely identified by its profile_layer_id
# (`tipo`).
require 'ap'

module Etl
  module Wosis
    class FindOrCreateLayer
      def process(row)
        wosis_id = "WoSIS #{row[:profile_id]}"

        profile = Perfil.find_by(numero: wosis_id)

        profile.horizontes.find_or_initialize_by tipo: row[:profile_layer_id] do |h|
          h.profundidad_superior = row[:top]
          h.profundidad_inferior = row[:bottom]

          h.build_analitico do |a|
            a.densidad_aparente = row[:bdws_value_avg]
            # FIXME It has non % values
            a.ca_co3 = row[:tceq_value_avg] if row[:tceq_value_avg].to_f < 100
            a.gravas = row[:cfvo_value_avg]
            a.t = row[:ecec_value_avg]
            a.conductividad = row[:elco_value_avg]
            # FIXME It has non % values
            a.carbono_organico_c = row[:orgc_value_avg] if row[:orgc_value_avg].to_f < 100
            a.ph_h2o = row[:phaq_value_avg]
            a.ph_kcl = row[:phkc_value_avg]
            a.arcilla = row[:clay_value_avg]
            a.limo_2_50 = row[:silt_value_avg]
            a.arena_total = row[:sand_value_avg]
            a.agua_util = row[:wrvo_value_avg]
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
