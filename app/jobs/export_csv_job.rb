class ExportCsvJob < ActiveJob::Base
  queue_as :default

  def perform(operation)
    profiles = Perfil.where(id: operation.profile_ids)

    file = Tempfile.new([file_name, '.csv'])

    File.open(file.path, File::RDWR|File::CREAT) do |file|
      buf = CSVSerializer.new(profiles).as_csv(headers: true, base: Perfil)
      file.write(buf)
    end

    operation.update finished: true, results: File.open(file)

    file.close
    file.unlink
  end

  def file_name
    nombre = []
    nombre << 'perfiles'
    nombre << Date.today.strftime('%Y-%m-%d')

    return nombre.join('_') + '_'
  end
end
