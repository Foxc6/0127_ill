class AddActivityIdToFileAttachments < ActiveRecord::Migration
  def change
    add_reference :file_attachments, :activity, index: true
  end
end
