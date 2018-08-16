# Parse user Profile/Layer data from our custom CSV format
require 'etl/common/sources/csv_source'
require 'etl/common/processors/transcoder'
require 'etl/user_csv/transformations/find_or_create_profile'
require 'etl/user_csv/transformations/find_or_create_layer'

module Etl
  module UserCsv
    class Job
      def import!(file, profile_attributes = {})
        transcoder = Transcoder.new(file)

        job = Kiba.parse do
          pre_process do
            transcoder.transcode!
          end

          source CsvSource, transcoder.destination

          # Adds a `system_profile_id` to the row
          transform FindOrCreateProfile, profile_attributes
          transform FindOrCreateLayer

          post_process do
            transcoder.destination.close
            transcoder.destination.unlink
          end
        end

        Kiba.run(job)
      end
    end
  end
end
