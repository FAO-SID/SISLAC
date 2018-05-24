# GeoJSON Profiles cache generation and busting
module GeojsonCache
  extend ActiveSupport::Concern

  included do
    # Only Profiles Controller exports GeoJSON, but other controllers can bust the cache
    if self == PerfilesController
      respond_to :geojson, only: [:index, :show]

      caches_page :index, :show, gzip: :best_compression, if: :geojson_request?
    end
  end

  def geojson_request?
    request.format.geojson?
  end

  # We can get a single profile, none, or a collection
  def expire_geojson(target = nil)
    if target.respond_to?(:each)
      target.each { |profile| expire_profile_geojson profile }
    else
      expire_profile_geojson target
    end
  end

  # Every time a Profile or its relationships are modified (updated, created,
  # destroyed) we bust the index and that specific cached profile
  def expire_profile_geojson(profile = nil)
    I18n.available_locales.each do |locale|
      with_options locale: locale, controller: :perfiles, format: :geojson do |common|
        common.expire_page action: :show, id: profile if profile.present?
        common.expire_page action: :index
      end
    end
  end
end
