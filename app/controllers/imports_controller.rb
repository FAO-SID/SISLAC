# Handles everything associated with bulk imports of data, usually through CSV
class ImportsController < AutorizadoController
  include GeojsonCache

  skip_authorization_check only: [:index, :new]

  # Landing with explanation of the process and links to new/post
  def index
  end

  # Downloads the CSV template with keyed columns
  def new
    send_data Import.template, filename: 'layers_template.csv',
      type: 'text/csv', disposition: 'inline'
  end

  # Uploads a CSV file with layer information
  def create
    authorize! :create, Perfil

    file = params[:csv_import]

    if Import.new(csv: file.path, owner: current_usuario).save
      expire_geojson

      flash[:notice] = 'Perfiles importados correctamente'
    else
      flash[:error] = 'Sucedió un error'
    end

    respond_to do |format|
      format.html do
        redirect_to imports_path
      end
    end
  end

  helper_method :titulo_de_la_accion

  private

  def titulo_de_la_accion
    I18n.t 'imports.index.title'
  end
end
