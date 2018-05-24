Rails.application.configure do
  # Enable the asset pipeline
  config.assets.enabled = true

  # Version of your assets, change this if you want to expire all your assets
  config.assets.version = '0.5'

  # Precompile additional assets.
  # application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
  config.assets.precompile += %w(
    ie.css
    print.css
    leaflet/dist/images/marker-icon.png
    leaflet/dist/images/marker-icon-2x.png
    leaflet/dist/images/marker-shadow.png
    leaflet/dist/images/layers.png
    leaflet/dist/images/layers-2x.png
  )
end
