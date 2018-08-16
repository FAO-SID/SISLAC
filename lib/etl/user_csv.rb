# Parse user Profile/Layer data from our custom CSV format
require 'etl/common/sources/csv_source'
require 'etl/user_csv/transformations/find_or_create_profile'
require 'etl/user_csv/transformations/find_or_create_layer'

module Etl
  module UserCsv
    class Job
      def import!(file, profile_attributes = {})
        job = Kiba.parse do
          source CsvSource, file

          # Adds a `system_profile_id` to the row
          transform FindOrCreateProfile, profile_attributes
          transform FindOrCreateLayer
        end

        Kiba.run(job)
      end
    end
  end
end
