# Select rows to process based on it's ISO code.
require 'countries'

module Etl
  module Wosis
    class FilterByCountry
      attr_reader :iso_codes

      def initialize(iso_codes:)
        @iso_codes = iso_codes
      end

      def process(row)
        iso_alpha2 = row[:country_id]

        iso_alpha3 =
          case iso_alpha2
          # AN/ANT is deprecated, so it's not recognizable by 'countries' gem. We have
          # to treat it as an exception until we develop something for obsolete data.
          #
          # See https://github.com/FAO-GSP/SISLAC/issues/3
          when 'AN'
            'ANT'
          else
            # Search country by alpha2 code.
            country = ISO3166::Country.new iso_alpha2

            # Returns nil if none found.
            country && country.alpha3
          end

        # Discard rows from countries that aren't specified.
        iso_codes.include?(iso_alpha3) ? row : nil
      end
    end
  end
end
