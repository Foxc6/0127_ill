class AddAttachmentThumbnailImageToProjects < ActiveRecord::Migration
  def self.up
    change_table :projects do |t|
      t.attachment :thumbnail_image
    end
  end

  def self.down
    remove_attachment :projects, :thumbnail_image
  end
end
