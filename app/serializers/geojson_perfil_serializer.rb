class GeojsonPerfilSerializer < ActiveModel::Serializer
  # `clase` es grupo + fase
  attributes :id, :numero, :fecha, :clase, :serie, :url, :publico

  def as_json(*args)
    Rails.cache.fetch ['geojson_perfil_serializer', object] do
      self.to_feature
    end
  end

  def to_feature
    factory = RGeo::GeoJSON::EntityFactory.instance
    factory.feature(object.coordenadas, nil, attributes)
  end

  # TODO Testear comportamiento cuando no hay serie
  def serie
    { 'nombre' => object.serie.nombre,
      'url' => serie_url(I18n.locale, object.serie) } if object.serie.present?
  end

  def url
    perfil_url I18n.locale, object
  end
end
