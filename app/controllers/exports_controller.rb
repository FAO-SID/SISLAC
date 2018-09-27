class ExportsController < AutorizadoController
  def index
    authorize! :read, Perfil

    @operation = current_usuario.operations.create(
      name: 'Exportar a CSV',
      profile_ids: current_usuario.current_selection
    )

    ExportCsvJob.perform_later @operation

    flash[:notice] = 'Estamos procesando su solicitud'
    redirect_to operation_path(@operation)
  end
end
