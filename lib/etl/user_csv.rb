# Parse user Profile/Layer data from our custom CSV format
require 'kiba-common/sources/csv'
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

          source Kiba::Common::Sources::CSV, filename: transcoder.destination,
            csv_options: {
              headers: true, header_converters: :symbol, col_sep: ',', encoding: 'utf-8'
            }

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
