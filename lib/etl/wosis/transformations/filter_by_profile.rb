# Filter layer rows based on existing profiles
module Etl
  module Wosis
    class FilterByProfile
      def process(row)
        wosis_id = "WoSIS #{row[:profile_id]}"

        Perfil.where(numero: wosis_id).any? ? row : nil
      end
    end
  end
end
