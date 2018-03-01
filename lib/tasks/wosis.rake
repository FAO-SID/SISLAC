require 'wosis'

namespace :etl do
  namespace :wosis do
    desc 'Parse wosis db csv and load data through our models'
    task import: :environment do
      Wosis.new(file_prefix: 'wosis_201607').import!
    end
  end
end
