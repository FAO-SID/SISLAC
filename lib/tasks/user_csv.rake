require 'etl/user_csv'

namespace :etl do
  namespace :user_csv do
    desc 'Parse our own csv template and load data through our models'
    task import: :environment do
      Etl::UserCsv::Job.new.import! ENV['USER_CSV_FILE']
    rescue ArgumentError => e
      Rails.logger.error e.message
      Rails.logger.error "Missing 'USER_CSV_FILE' param for importing profiles"
    end
  end
end
