class OperationsController < AutorizadoController
  load_and_authorize_resource through: :current_usuario

  def index
    @operations = @operations.decorate
  end

  def show
    @operation = @operation.decorate
  end

  def download
    send_file @operation.results.path, type: 'text/csv' 
  end
end
