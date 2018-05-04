require 'google_drive'
require 'json'
require 'retryable'

module UsesGoogleDrive
  extend ActiveSupport::Concern
  def google_config_path
    File.expand_path('../../../config/config.json', File.dirname(__FILE__))
  end

  def google_client
    @google_client ||= GoogleDrive::Session.from_config(google_config_path)
  end

  def google_drive_upload(filepath, file)
    google_client.upload_from_file(filepath, file, convert: false)
  end

  def google_drive_download(drive_filepath, destination_filepath)
    file = google_client.file_by_title(drive_filepath)
    file.download_to_file(destination_filepath)
  end
end
