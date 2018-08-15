require 'etl/wosis'

namespace :etl do
  namespace :wosis do
    desc 'Parse wosis db csv and load data through our models'
    task import: :environment do
      user = Usuario.find_by! email: ENV['WOSIS_USER']
      release_date = Date.new(2016, 07)

      Etl::Wosis::Job.new(
        file_prefix: ENV['WOSIS_FILE_PREFIX'],
        profile_attributes: { usuario: user, fecha: release_date }
      ).import!
    rescue ArgumentError => e
      Rails.logger.error e.message
      Rails.logger.error "Missing 'wosis_file_prefix' param for importing profiles"
    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.error e.message
      Rails.logger.error "Missing 'wosis_user' param with the uploader email"
    end
  end
end
