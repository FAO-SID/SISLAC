class OperationDecorator < ApplicationDecorator
  def state
    object.finished? ? 'Completada' : 'Pendiente'
  end

  def download_link
    h.link_to object.results.original_filename, h.download_operation_path(object) if object.finished?
  end

  def start_time
    h.l object.created_at, format: :short
  end
end
