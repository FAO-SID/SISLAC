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

  # Every time a Profile or its relationships are modified (updated, created,
  # destroyed) we bust the index and that specific cached profile.
  #
  # We can get a single profile, none, or a collection
  def expire_geojson(target = nil)
    if target.respond_to?(:each)
      target.each { |profile| expire_profile_geojson profile }
    elsif target.present?
      expire_profile_geojson target
    end

    expire_profiles_geojson
  end

  # Expire a single profile in every locale
  def expire_profile_geojson(profile = nil)
    I18n.available_locales.each do |locale|
      expire_page base_params.merge(action: :show, locale: locale, id: profile) if profile.present?
    end
  end

  # Expire profiles indices in every locale and regenerate them
  def expire_profiles_geojson
    I18n.available_locales.each do |locale|
      page_params = base_params.merge(action: :index, locale: locale)

      expire_page page_params
      WarmCacheJob.perform_later url_for(page_params)
    end
  end

  private

  # Common params in every geojson request
  def base_params
    { controller: :perfiles, format: :geojson }
  end
end
