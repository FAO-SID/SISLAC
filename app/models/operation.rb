class Operation < ActiveRecord::Base
  belongs_to :usuario

  has_attached_file :results, validate_media_type: false
  do_not_validate_attachment_file_type :results
end
