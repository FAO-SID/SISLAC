class OperationDecorator < ApplicationDecorator
  def state
    object.finished? ? 'Completada' : 'Pendiente'
  end

  def download_link
    h.link_to file_name, h.download_operation_path(object), download: file_name if object.finished?
  end

  def start_time
    h.l object.created_at, format: :short
  end

  def file_name
    object.results.try :original_filename
  end
end
