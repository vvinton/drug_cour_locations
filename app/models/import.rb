class Import < ApplicationRecord
  has_attached_file :mdb
  do_not_validate_attachment_file_type :mdb
end
