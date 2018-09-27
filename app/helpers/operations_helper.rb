module OperationsHelper
  def selection_size
    current_usuario.current_selection.try(:size)
  end

  def titulo_de_la_accion
    case params[:action]
    when 'index'
      'Operaciones con perfiles'
    when 'show'
      "Operación #{@operation.id}"
    else
      nil
    end
  end
end
