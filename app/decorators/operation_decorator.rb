class OperationDecorator < ApplicationDecorator
  def state
    object.finished? ? 'Completada' : 'Pendiente'
  end

  def download_link
    h.link_to object.results.original_filename, h.download_operation_path(object) if object.finished?
  end
end
