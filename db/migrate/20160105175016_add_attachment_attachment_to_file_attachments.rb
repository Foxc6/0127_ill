class AddAttachmentAttachmentToFileAttachments < ActiveRecord::Migration
  def self.up
    change_table :file_attachments do |t|
      t.attachment :attachment
    end
  end

  def self.down
    remove_attachment :file_attachments, :attachment
  end
end
