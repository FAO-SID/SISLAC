class ExportsController < AutorizadoController
  def index
    authorize! :read, Perfil

    @perfiles = Perfil.where(id: current_usuario.try(:current_selection))

    respond_with @perfiles, location: nil do |format|
      format.csv do
        send_data CSVSerializer.new(@perfiles).as_csv(
          headers: true,
          base: Perfil
        ), filename: archivo_csv
      end
    end
  end

  def archivo_csv(perfil = nil)
    nombre = []

    if perfil
      nombre << 'perfil'
      nombre << perfil.to_s
    else
      nombre << 'perfiles'
    end

    nombre << Date.today.strftime('%Y-%m-%d')

    return "#{nombre.join('_')}.csv"
  end
end
