class ExportCsvJob < ActiveJob::Base
  queue_as :default

  def perform(operation)
    profiles = Perfil.where(id: operation.profile_ids)

    file = Tempfile.new([base_file_name, '.csv'])

    # Only create headers the first iteration
    headers = true

    # Open the file only once
    File.open(file.path, File::RDWR|File::CREAT) do |file|
      # Iterate over all the Profiles as batch
      # FIXME Use .in_batches on rails >= 5
      profiles.find_in_batches do |batch|
        # And write in batches
        buf = CSVSerializer.new(batch).as_csv(headers: headers, base: Perfil)
        file.write(buf)

        headers = false
      end
    end

    operation.update finished: true, results: File.open(file)

    file.close
    file.unlink
  end

  def base_file_name
    Perfil.model_name.human(count: 2) + '_'
  end
end
