require 'etl/user_csv'

namespace :etl do
  namespace :user_csv do
    desc 'Parse our own csv template and load data through our models'
    task import: :environment do
      user = Usuario.find_by! email: ENV['USER_CSV_EMAIL']

      raise ArgumentError unless ENV['USER_CSV_FILE'].present?

      Etl::UserCsv::Job.new.import! ENV['USER_CSV_FILE'], usuario: user
    rescue ArgumentError => e
      Rails.logger.error e.message
      Rails.logger.error "Missing 'USER_CSV_FILE' param for importing profiles"

    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.error e.message
      Rails.logger.error "User not found for email: 'USER_CSV_EMAIL'"
    end
  end
end
