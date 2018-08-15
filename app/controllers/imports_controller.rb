# Handles everything associated with bulk imports of data, usually through CSV
class ImportsController < AutorizadoController
  include GeojsonCache

  skip_authorization_check only: [:new, :template]

  # Landing with explanation of the process and form to post
  def new
    @import = Import.new license_id: License.default.to_param
  end

  # Downloads the template with keyed columns
  def template
    respond_to do |format|
      format.csv do
        send_data Import.template, filename: 'layers_template.csv',
          type: 'text/csv', disposition: 'inline'
      end
    end
  end

  # Uploads a CSV file with layer information
  def create
    authorize! :create, Perfil

    import = Import.new import_params.merge({ user: current_usuario })

    if import.save
      expire_geojson

      flash[:notice] = 'Perfiles importados correctamente'
    else
      flash[:error] = 'Sucedió un error'
    end

    respond_to do |format|
      format.html do
        redirect_to new_import_path
      end
    end
  end

  helper_method :titulo_de_la_accion

  private

  def titulo_de_la_accion
    I18n.t 'imports.new.title'
  end

  def import_params
    params.require(:import).permit(
      :file, :producer, :type_id, :license_id
    )
  end
end
