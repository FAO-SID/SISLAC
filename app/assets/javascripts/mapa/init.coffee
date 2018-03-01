jQuery ->
  # Si hay un mapa en la página
  if $('#mapa').length
    # Show the world by default but use configured values if present
    zoom = $('#mapa').data('zoom') || 2
    center = $('#mapa').data('center') || [0, 0]

    mapa = L.map('mapa', {
      center: center
      zoom: zoom
      zoomControl: false
    })

    osm = L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      maxZoom: 18
      attribution: '&copy; <a href="http://openstreetmap.org/copyright">OpenStreetMap</a> contributors (' +
        '<a href="http://opendatacommons.org/licenses/odbl/">ODbL</a>)'
    })

    g_terreno = L.gridLayer.googleMutant({ type: 'terrain' })
    g_hibrido = L.gridLayer.googleMutant({ type: 'hybrid' })

    # Capa inicial
    mapa.addLayer(g_hibrido)

    # Capa de geoJson
    geojson = L.geoJson()
    # Capa de clusters
    clusters = L.markerClusterGroup()

    # Controles de zoom, capas e info
    L.control.zoom({
      position: 'topright'
    }).addTo(mapa)

    # Control para cambiar de capas
    L.control.layers({
      'OpenStreetMap': osm
      'Google': g_hibrido
      'Google Terrain': g_terreno
    }, {
      'Perfiles públicos': clusters
    }).addTo(mapa)

    L.control.info({
      title: $('#mapa').data('infoTitle')
      text: $('#mapa').data('infoText')
    }).addTo(mapa)

    # Al seleccionar un rectángulo con shift + click, enviamos las coordenadas
    # del rectángulo para seleccionar todos los perfiles internos
    # FIXME Extraer a mapa/config
    mapa.on 'boxzoomend', (e) ->
      # TODO Revisar si _metodo son APIs internas
      caja = e.boxZoomBounds

      seleccion = new L.Rectangle(caja, {
        color: 'red'
        weight: 3
        opacity: 0.5
        smoothFactor: 1
        className: 'mapa_seleccion'
      })

      # Dibuja la selección actual
      $('.mapa_seleccion').remove()
      seleccion.addTo(mapa)

      coordenadas =
        noreste:
          latitud: caja._northEast.lat
          longitud: caja._northEast.lng
        sudoeste:
          latitud: caja._southWest.lat
          longitud: caja._southWest.lng

      # Envia bounds al server y procesar la respuesta
      # FIXME Arreglar flash
      $.post $(this._container).data('seleccion-url'), coordenadas, (res) ->
        $('#avisos').html $('<div />', { id: "flash_#{res.tipo}", text: res.mensaje })

    # Pide y agrega los puntos
    $.getJSON $('#mapa').data('geojson'), (data) ->
      clusters.addLayer(
        # Agrega una capa de geoJson
        geojson.addData(data, {
          onEachFeature: Mapa.preparar_punto
        })
      ).addTo(mapa)
