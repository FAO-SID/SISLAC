class WarmCacheJob < ActiveJob::Base
  queue_as :default

  def perform(url)
    session = ActionDispatch::Integration::Session.new(Rails.application)

    session.get url
  end
end
