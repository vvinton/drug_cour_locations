class Import < ApplicationRecord
  include UsesGoogleDrive
  has_attached_file :mdb
  do_not_validate_attachment_file_type :mdb

  def save_to_google_drive
    google_drive_upload(mdb.path, google_store_filename(mdb_file_name))
  end

  def google_store_filename(filename)
    "/AmericanUniversity/temporary_upload_storage/#{filename}"
  end
end
