class GeojsonCollectionSerializer < ActiveModel::ArraySerializer
  def as_json(*args)
    factory = RGeo::GeoJSON::EntityFactory.instance

    RGeo::GeoJSON.encode factory.feature_collection(features)
  end

  def features
    perfiles = []

    object.find_each do |perfil|
      perfiles << GeojsonPerfilSerializer.new(perfil.decorate).as_json
    end

    perfiles
  end
end
