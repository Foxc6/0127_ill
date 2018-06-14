class FileAttachment < ActiveRecord::Base
  belongs_to :activity
  has_attached_file :attachment
  validates_attachment :attachment,
    content_type: { content_type: ["image/jpeg", "image/gif", "image/png", "application/pdf", "application/vnd.ms-excel", "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "application/msword", "application/vnd.openxmlformats-officedocument.wordprocessingml.document", ]}
end
